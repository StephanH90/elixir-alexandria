# Alexandria Port — Design

**Date:** 2026-05-12
**Status:** Approved
**Owner:** Stefano Hug

## Summary

Port the open-source Django document-management library [`caluma-alexandria` 8.8.1](https://pypi.org/project/caluma-alexandria/) — currently used by ebau cantons via `~/Documents/camac/elixir/django/camac/alexandria/` — to a standalone Phoenix/LiveView/Ash library named **`alexandria`**.

The new library mirrors the shape proven by `caluma_poc`: an Ash library + Phoenix `dev/` sub-app + Spark fragment extension for consumer overrides. It will eventually be consumed by `elixir-ebau` to replace the canton's Django Alexandria + canton-specific patches.

## Decisions

| Question | Decision |
|---|---|
| Where does the port live? | Standalone library at `~/Documents/elixir-experiments/alexandria/` (sibling of `caluma_poc`). Name is `alexandria` — no `_poc` suffix. |
| v1 scope | Category, Document, File, Tag, TagSynonymGroup, Mark + permissions + S3 file storage. |
| Deferred to v2 | WebDAV, multilingual full-text search (tsvector), background thumbnail/rendering jobs, audit log, first-class soft delete. |
| Permissions | Ash-native `Ash.Policy.Authorizer`; per-action semantic action names (no generic `:update`); consumer adds policies via Spark fragments. |
| API surface | LiveComponent only. No REST/GraphQL. |
| DB schema | 1:1 with existing Django Alexandria tables. Django + Elixir can read+write the same DB during migration. |
| Schema mapping | Expressed via Ash resource DSL (`postgres do table … end`, `source:`, `references`, `check_constraints`). Migrations are generated, never hand-edited. |
| File storage | `Alexandria.Storage` behaviour with `ExAws` default adapter (talks to Garage / any S3). InMemory adapter for tests. |
| Embedding | Always embedded inside a host LiveView ("one tab among many"). LiveComponent only; host owns URL. |
| URL scheme | Query-params-only on the host's existing route. Never navigate away. `?category=foo&document=uuid1,uuid2&sort=...`. |
| Component contract | Two assigns: `scope` (Phoenix 1.8 scope; carries actor + locale + canton context) and `params` (host's `socket.assigns.params`). |
| Local S3 | Garage container, reusing `~/Documents/camac/elixir/garage/` compose recipe. |
| Integration testing | PhoenixTest in `dev/` sub-app. |

## 1. Project skeleton

Location: `~/Documents/elixir-experiments/alexandria/`.

```
alexandria/
├── mix.exs                       # :alexandria, Elixir 1.19
├── config/{config,dev,test,runtime}.exs
├── lib/
│   ├── alexandria.ex
│   ├── alexandria/
│   │   ├── core.ex               # Ash.Domain — registers all v1 resources
│   │   ├── core/
│   │   │   ├── category.ex
│   │   │   ├── document.ex
│   │   │   ├── file.ex
│   │   │   ├── tag.ex
│   │   │   ├── tag_synonym_group.ex
│   │   │   ├── mark.ex
│   │   │   ├── document_tag.ex
│   │   │   └── document_mark.ex
│   │   ├── fragment_extension.ex
│   │   ├── fragment_extension/transformer.ex
│   │   ├── storage.ex            # behaviour
│   │   ├── storage/ex_aws.ex
│   │   ├── types/multilingual.ex # custom Ash type for i18n JSONB
│   │   └── repo.ex
│   └── alexandria_web/
│       └── browser.ex            # single LiveComponent
├── dev/                          # separate mix project
│   ├── mix.exs                   # depends on {:alexandria, path: ".."}
│   ├── docker-compose.yml        # Postgres + Garage
│   ├── config/{config,dev,test,runtime}.exs
│   ├── lib/
│   │   ├── alexandria_dev/{application,scope}.ex   # reuses Alexandria.Repo
│   │   └── alexandria_dev_web/{endpoint,router,browser_live}.ex
│   ├── priv/repo/seeds.exs       # loads dump.json
│   └── test/
├── priv/repo/migrations/         # ash_postgres-generated
├── test/
├── README.md
└── CLAUDE.md
```

Lib dependencies: `ash ~> 3.23`, `ash_postgres ~> 2.0`, `ash_phoenix ~> 2.0`, `spark`, `phoenix ~> 1.8`, `phoenix_live_view ~> 1.1`, `ex_aws ~> 2.5`, `ex_aws_s3 ~> 2.5`, `sweet_xml`, `req`, `gettext`, `elixir_uikit ~> 0.7`. Dev/test: `usage_rules`, `igniter`, `live_debugger`, `phoenix_test`.

## 2. Data model

All tables match the Django Alexandria layout exactly. Multilingual fields are JSONB maps shaped `{"de-ch": "...", "en": "...", …}` — same as `dump.json`.

| Resource | Table | PK | Key attributes | Relations |
|---|---|---|---|---|
| `Alexandria.Core.Category` | `alexandria_core_category` | `id :string` (slug) | `name`, `description` (multilingual JSONB), `color :string`, `sort :integer`, `metainfo :map`, `created_at`, `modified_at`, `created_by_user :string`, `created_by_group :string` | `belongs_to :parent, Category`; `has_many :children`; `has_many :documents` |
| `Alexandria.Core.Document` | `alexandria_core_document` | `id :uuid_v4` | `title`, `description` (i18n), `date :date`, `metainfo`, audit ts/user/group | `belongs_to :category`; `has_many :files`; `many_to_many :tags, :marks` |
| `Alexandria.Core.File` | `alexandria_core_file` | `id :uuid_v4` | `name :string`, `variant :atom` (`:original \| :thumbnail \| :rendering`), `content :string` (S3 key), `mime_type :string`, `size :integer`, `metainfo`, audit | `belongs_to :document`; `belongs_to :original, File` |
| `Alexandria.Core.Tag` | `alexandria_core_tag` | `id :string` (slug) | `name`, `description` (i18n), `metainfo`, audit | `belongs_to :tag_synonym_group`; `many_to_many :documents` |
| `Alexandria.Core.TagSynonymGroup` | `alexandria_core_tagsynonymgroup` | `id :uuid_v4` | `name` (i18n) | `has_many :tags` |
| `Alexandria.Core.Mark` | `alexandria_core_mark` | `id :string` (slug) | `name`, `description` (i18n), `metainfo`, audit | `many_to_many :documents` |
| `Alexandria.Core.DocumentTag` | `alexandria_core_document_tags` | `(document_id, tag_id)` | — | join |
| `Alexandria.Core.DocumentMark` | `alexandria_core_document_marks` | `(document_id, mark_id)` | — | join |

`created_by_user` / `created_by_group` stay as plain strings (no FK enforced) — matches Django, where the canton joins via Service/User in its own domain.

### Schema mapping (Ash resource DSL — example)

```elixir
defmodule Alexandria.Core.Category do
  use Ash.Resource,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [Alexandria.FragmentExtension]

  postgres do
    table "alexandria_core_category"
    repo Alexandria.Repo

    references do
      reference :parent,
        name: "alexandria_core_category_parent_id_fkey",
        on_delete: :restrict
    end

    check_constraints do
      check_constraint :color,
        name: "alexandria_core_category_color_check",
        check: "color ~ '^#[0-9a-fA-F]{6}$'"
    end

    custom_indexes do
      index [:parent_id], name: "alexandria_core_category_parent_id_idx"
    end
  end

  attributes do
    attribute :id, :string, primary_key?: true, allow_nil?: false, public?: true
    attribute :name, Alexandria.Types.Multilingual, allow_nil?: false, public?: true
    attribute :description, Alexandria.Types.Multilingual, public?: true
    attribute :color, :string, allow_nil?: false
    attribute :sort, :integer, default: 0, allow_nil?: false
    attribute :metainfo, :map, default: %{}, allow_nil?: false
    attribute :created_by_user, :string
    attribute :created_by_group, :string
    create_timestamp :created_at
    update_timestamp :modified_at
  end

  relationships do
    belongs_to :parent, __MODULE__,
      attribute_type: :string,
      source_attribute: :parent_id,
      destination_attribute: :id
    has_many :children, __MODULE__, destination_attribute: :parent_id
    has_many :documents, Alexandria.Core.Document
  end
end
```

Workflow: run `mix ash.codegen --name initial_alexandria_schema` against an empty DB. `pg_dump --schema-only` it; diff against `pg_dump --schema-only` of a Django-migrated DB. Iterate on the resource DSL until the diff is empty. Migration files are checked in untouched.

## 3. Action surface

No generic `:update` actions. Each domain operation gets its own action with a semantic name and its own policy target.

### Category

`:read`, `:list_roots`, `:list_children`, `:create_root`, `:create_child`, `:rename`, `:recolor`, `:reorder`, `:set_metainfo`, `:destroy`.

### Document

`:read`, `:list_by_category`, `:by_tag`, `:by_mark`, `:upload` (creates document + initial File + storage put in one transaction), `:rename`, `:edit_description`, `:set_date`, `:move_to_category`, `:set_metainfo`, `:add_tag`, `:remove_tag`, `:add_mark`, `:remove_mark`, `:replace_original_file`, `:archive` / `:restore` (toggle `metainfo.archived_at`), `:destroy`.

### File

`:read`, `:for_document`, `:upload_original`, `:upload_thumbnail`, `:upload_rendering`, `:rename`, `:replace_content`, `:destroy`, `:download_url` (returns presigned URL).

### Tag, TagSynonymGroup, Mark

Tag: `:read`, `:create`, `:rename`, `:join_synonym_group`, `:leave_synonym_group`, `:destroy`.
TagSynonymGroup: `:read`, `:create`, `:rename`, `:destroy`.
Mark: `:read`, `:create`, `:rename`, `:destroy`.

### Upstream-clean rule

No action references ebau / canton concepts. Anything keyed on instance/service/dossier belongs in a consumer-side fragment, not in the library. Example: `Document.for_instance` is **not** in the lib — `elixir-ebau` adds it via a fragment.

### Default policy

Every resource ships a fully permissive base policy (`authorize_if always()`). Fragment-added policies AND with the base, so consumers can only narrow. Use `bypass` for admin-actor escape hatches.

## 4. Storage behaviour

```elixir
defmodule Alexandria.Storage do
  @callback put(key :: String.t(), content, opts :: keyword) :: :ok | {:error, term}
  @callback delete(key :: String.t()) :: :ok | {:error, term}
  @callback presigned_url(key :: String.t(), opts :: keyword) :: {:ok, String.t()} | {:error, term}
  @callback exists?(key :: String.t()) :: boolean

  def put(k, c, o \\ []), do: adapter().put(k, c, o)
  def delete(k), do: adapter().delete(k)
  def presigned_url(k, o \\ []), do: adapter().presigned_url(k, o)
  def exists?(k), do: adapter().exists?(k)

  defp adapter, do: Application.fetch_env!(:alexandria, :storage)[:adapter]
end
```

Adapters:
- `Alexandria.Storage.ExAws` — default, wraps `ExAws.S3` + `ExAws.S3.Upload` + `ExAws.S3.presigned_url/4`.
- `Alexandria.Storage.InMemory` — test-only, Agent-backed.

Config (env vars match Django's `ALEXANDRIA_S3_*` names so canton secrets carry over unchanged):

```elixir
config :alexandria, :storage,
  adapter: Alexandria.Storage.ExAws,
  bucket: System.fetch_env!("ALEXANDRIA_S3_BUCKET"),
  access_key_id: System.fetch_env!("ALEXANDRIA_S3_ACCESS_KEY_ID"),
  secret_access_key: System.fetch_env!("ALEXANDRIA_S3_SECRET_ACCESS_KEY"),
  endpoint_url: System.fetch_env!("ALEXANDRIA_S3_ENDPOINT_URL"),
  region: System.get_env("ALEXANDRIA_S3_REGION", "garage"),
  presigned_url_ttl_seconds: 3600
```

Resource actions that touch storage:
- `File.upload_*`: action generates the S3 key (`Ecto.UUID.generate()`), calls `Storage.put`, then sets the `:content` attribute. Ash wraps in a transaction — storage failure rolls back the DB row.
- `File.replace_content`: queues the old key for delete via an `after_action` hook.
- `File.destroy`: `after_action` hook calls `Storage.delete`. Storage failure logs but does not fail the destroy (matches Django; drift is reconciled by a `mix alexandria.check_storage_consistency` task).
- `File.download_url`: returns `{:ok, presigned_url}` with the configured TTL.

## 5. Fragment extension

```elixir
defmodule Alexandria.FragmentExtension do
  @moduledoc false
  use Spark.Dsl.Extension,
    transformers: [Alexandria.FragmentExtension.Transformer]
end

defmodule Alexandria.FragmentExtension.Transformer do
  @moduledoc false
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer, as: DslTransformer

  def transform(dsl_state) do
    module = DslTransformer.get_persisted(dsl_state, :module)
    otp_app = DslTransformer.get_persisted(dsl_state, :otp_app)

    fragments =
      case otp_app && Application.get_env(otp_app, module) do
        nil -> []
        config -> Keyword.get(config, :fragments, [])
      end

    {:ok, Spark.Dsl.handle_fragments(dsl_state, fragments)}
  end
end
```

Wired on every resource (`extensions: [Alexandria.FragmentExtension]`) and on the `Alexandria.Core` domain.

Consumer registers fragments per target module:

```elixir
config :alexandria, Alexandria.Core.Document,
  fragments: [Ebau.Alexandria.DocumentInstancePolicies, Ebau.Alexandria.DocumentInstanceActions]
config :alexandria, Alexandria.Core.Category,
  fragments: [Ebau.Alexandria.CategoryVisibilities]
config :alexandria, Alexandria.Core,
  fragments: [Ebau.Alexandria.DomainCrossActions]
```

Fragments may add `policies` (AND-merged with the base), `actions`, `calculations`, `aggregates`, `validations`, `preparations`, `changes`, non-persisted `relationships`. Fragments **may not** add persisted attributes, change `table` / `repo` / `identities`, or alter `data_layer:` / `authorizers:`. Consumer-owned state lives in the existing `metainfo` JSONB column or in a sidecar resource in the consumer's own domain.

### Example consumer fragment

```elixir
defmodule Ebau.Alexandria.DocumentInstanceFragment do
  use Spark.Dsl.Fragment, of: Ash.Resource

  actions do
    read :for_instance do
      argument :instance_id, :integer, allow_nil?: false
      filter expr(fragment("(metainfo->>'camac-instance-id')::int = ?", ^arg(:instance_id)))
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if expr(
        fragment("(metainfo->>'camac-instance-id')::int") == ^context(:instance_id)
      )
    end
  end
end
```

## 6. Embedding contract

The library ships **only** a LiveComponent. Host LiveView owns the URL.

### Component surface

```heex
<.live_component module={AlexandriaWeb.Browser} id="alexandria"
  scope={@current_scope} params={@params} />
```

- **`scope`** — Phoenix 1.8 scope struct. Lib uses `scope.actor` for Ash authorization, `scope.locale` for multilingual rendering (falls back to `Gettext.get_locale()` then `"en"` if absent). Host's scope must implement `Ash.Scope.ToOpts`. Canton scope (`Ebau.Scope`) carries `current_user`, `current_instance`, `current_service`, `locale`; fragment policies read whatever they need via `^context(:foo)` / `^actor(:foo)`.
- **`params`** — host's `socket.assigns.params`. Component reads `params["category"]`, `params["document"]`, `params["sort"]`, etc. Multi-select documents via comma-separated UUIDs (`"uuid1,uuid2"`).

The lib does not define its own scope struct. The `dev/` sub-app has a minimal `AlexandriaDev.Scope` for the demo only.

### Host integration

```elixir
# in host LV
def handle_params(params, _, socket), do: {:noreply, assign(socket, :params, params)}
```

One line. Component owns its URL state via `push_patch(socket, to: "?#{URI.encode_query(new_params)}")` from its own `handle_event/3` callbacks. No path interpolation — the lib never touches anything but the query string.

### URL scheme

Single-route, query-params-only. Examples:

- `myapp.com/building/3/documents`
- `myapp.com/building/3/documents?category=intern`
- `myapp.com/building/3/documents?category=intern&document=uuid1,uuid2&sort=title_asc&page=2&q=foo`

Conventions:
- `category` — single slug
- `document` — comma-separated UUID list (multi-select opens multiple detail panels / tabs)
- `sort`, `page`, `q` — scalars

### File upload

`Phoenix.LiveView.allow_upload/3` with `:external` writer that calls `Alexandria.Storage.presigned_url(key, method: :put)`. Browser uploads directly to Garage/S3; component then invokes the Ash `:upload` action with the pre-uploaded key. ~15 lines inside the component.

### Why no callbacks

The component never calls user-supplied `on_*` callbacks. If a host eventually needs cross-process notifications it can subscribe to Ash notifications via `Phoenix.PubSub` — but v1 ships nothing of the sort. Add only when a consumer asks for it.

## 7. Testing strategy

| Layer | Where | Scope |
|---|---|---|
| Resource actions | `test/alexandria/core/*_test.exs` | One test per semantic action: happy path + one denied-policy path. No mocks. |
| Storage behaviour | `test/alexandria/storage_test.exs` | Parameterized contract test against both `InMemory` and (tagged `:garage`) `ExAws` adapters. |
| Fragment extension | `test/alexandria/fragment_extension_test.exs` | One test: register a fragment, assert action/policy visible on the resource. |
| LiveComponent integration | `dev/test/alexandria_dev_web/browser_test.exs` | PhoenixTest walk: select category → upload → open doc → edit title → tag → delete. Uses real Ash + InMemory storage by default; `:garage`-tagged variant hits live Garage. |

No factory libs. Ash code-interface calls inside `setup` blocks build rows. `mix test` (lib) + `cd dev && mix test` (integration). Both wired into the `precommit` alias.

## 8. Build sequence

Each step is a PR-sized slice ending in a green test suite.

1. **Skeleton.** `mix new`, deps, base config, CLAUDE.md, `Alexandria.Repo`, `Alexandria.FragmentExtension` + transformer, `Alexandria.Types.Multilingual`, empty `Alexandria.Core` domain, `docker-compose.yml` (Postgres + Garage).
2. **Category resource.** Full DSL + semantic actions + permissive default policy. Generate migration; diff against Django schema; iterate until empty diff. Tests.
3. **Tag + Mark + TagSynonymGroup.** Three small resources, one PR.
4. **Document + join tables.** Semantic actions + tag/mark `manage_relationship`. `:upload` stubbed (no storage yet). Tests.
5. **Storage behaviour + InMemory adapter.** Module, behaviour, InMemory impl, contract test.
6. **File resource + ExAws adapter.** File resource, semantic actions wired to Storage. `Document.upload` lights up. Add `:garage`-tagged integration test.
7. **Dev sub-app shell.** `dev/` mix project, endpoint, repo, router, `dump.json` seed. `BrowserLive` renders root categories as plain HTML (sanity check).
8. **LiveComponent read paths.** `AlexandriaWeb.Browser` showing category tree + document list + document detail, driven by `params` assign. `push_patch` for selection. PhoenixTest integration test.
9. **LiveComponent mutations.** Rename, edit_description, set_date, move_to_category, add/remove tag/mark. Inline upload form with `:external` writer to Garage. Extend integration test.
10. **Lifecycle: archive + destroy.** `metainfo.archived_at` toggle, hard destroy with cascading file + storage cleanup. Final integration test pass.

After step 10 the library is feature-complete for v1. Steps 11+ are pure consumer work in `elixir-ebau`: write canton fragments (instance scoping, canton-specific actions) and embed the component into the canton's host LV.

## 9. Out of scope (deferred to v2)

- WebDAV endpoint
- Multilingual full-text search (no `:search` action in v1 at all — added in v2 with tsvector + GIN)
- Background thumbnail / PDF rendering jobs (oban)
- Audit log
- Soft delete as a first-class boolean / timestamp column (currently rides on `metainfo.archived_at`)
- JSON:API / GraphQL surface (Ember Alexandria's existing JSON:API consumer keeps pointing at Django until the Ember frontend is itself replaced)
- Storage adapters other than ExAws

## 10. References

- Upstream Django source: `~/Documents/camac/elixir/django/camac/alexandria/` and `caluma-alexandria` 8.8.1 on PyPI
- Canton patches (the bits to NOT port into the upstream library): `~/Documents/camac/elixir/django/camac/alexandria/`
- Demo fixture: `~/Documents/camac/elixir/alexandria/demo/dump.json`
- Reference port: `~/Documents/elixir-experiments/caluma_poc/` (especially `lib/caluma/fragment_extension.ex` and `dev/`)
- Garage compose recipe: `~/Documents/camac/elixir/garage/`
- Target consumer: `~/Documents/camac/elixir/elixir-ebau/`
