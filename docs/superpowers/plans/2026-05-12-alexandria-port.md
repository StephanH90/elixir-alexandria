# Alexandria Port Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port `caluma-alexandria` 8.8.1 (Django) to a standalone Elixir library `alexandria` providing Ash resources + a host-embeddable LiveComponent, backed by S3-compatible storage.

**Architecture:** Single `Alexandria.Core` Ash domain holding Category / Document / File / Tag / TagSynonymGroup / Mark resources, 1:1 schema with Django via the Ash resource DSL (no hand-edited migrations). Storage abstracted behind `Alexandria.Storage` behaviour with ExAws + InMemory adapters. Consumer extension via `Alexandria.FragmentExtension` (Spark) — canton policies/actions injected from `elixir-ebau`. One LiveComponent `AlexandriaWeb.Browser` for host embedding; URL state is query-params-only on the host's existing route. Dev sub-app at `dev/` for local demo + PhoenixTest integration coverage.

**Tech Stack:** Elixir 1.19, Ash 3.23, ash_postgres 2.0, ash_phoenix 2.0, Phoenix 1.8, LiveView 1.1, ex_aws + ex_aws_s3, elixir_uikit 0.7, Garage (S3-compatible local storage), PhoenixTest, Spark.

**Spec:** `docs/superpowers/specs/2026-05-12-alexandria-port-design.md`

---

## File Structure

```
alexandria/
├── mix.exs
├── docker-compose.yml
├── config/
│   ├── config.exs
│   ├── dev.exs
│   ├── test.exs
│   └── runtime.exs
├── lib/
│   ├── alexandria.ex
│   ├── alexandria/
│   │   ├── application.ex                  # supervision tree
│   │   ├── repo.ex                         # AshPostgres.Repo
│   │   ├── core.ex                         # Ash.Domain
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
│   │   ├── fragment_extension/
│   │   │   └── transformer.ex
│   │   ├── storage.ex                      # behaviour + dispatcher
│   │   ├── storage/
│   │   │   ├── ex_aws.ex
│   │   │   └── in_memory.ex
│   │   └── types/
│   │       └── multilingual.ex
│   └── alexandria_web/
│       └── browser.ex                      # single LiveComponent
├── priv/repo/migrations/                   # ash_postgres-generated
├── test/
│   ├── test_helper.exs
│   ├── support/
│   │   ├── data_case.ex
│   │   └── scope.ex                        # test scope struct
│   ├── alexandria/
│   │   ├── core/
│   │   │   ├── category_test.exs
│   │   │   ├── document_test.exs
│   │   │   ├── file_test.exs
│   │   │   ├── tag_test.exs
│   │   │   ├── tag_synonym_group_test.exs
│   │   │   └── mark_test.exs
│   │   ├── storage_test.exs                # behaviour contract (parameterised)
│   │   └── fragment_extension_test.exs
└── dev/
    ├── mix.exs
    ├── config/{config,dev,test,runtime}.exs
    ├── docker-compose.yml                  # symlink or copy of top-level
    ├── lib/
    │   ├── alexandria_dev.ex
    │   ├── alexandria_dev/
    │   │   ├── application.ex
    │   │   └── scope.ex
    │   └── alexandria_dev_web/
    │       ├── endpoint.ex
    │       ├── router.ex
    │       ├── components/
    │       │   ├── layouts.ex
    │       │   └── layouts/root.html.heex
    │       └── browser_live.ex
    ├── priv/repo/seeds.exs
    └── test/
        ├── test_helper.exs
        ├── support/conn_case.ex
        └── alexandria_dev_web/
            └── browser_live_test.exs
```

Each `lib/alexandria/core/*.ex` file is a single Ash resource — one responsibility, easy to hold in context. The browser LiveComponent uses private function components inline until any one of them earns its own file.

The `Alexandria.Core` domain declares `define` code interfaces for every action that has a real caller (tests, LiveComponent, dev seeds, dev test, and `Document.upload`'s after-action). All call sites use those domain functions (`Alexandria.Core.create_root_category/2`, `Alexandria.Core.list_documents_by_category/2`, `Alexandria.Core.rename_document/3`, …) rather than raw `Ash.create/2`, `Ash.read/2`, etc. The join tables (`DocumentTag`, `DocumentMark`) have no interfaces — callers go through Document. Resource internals (changes, generic-action `run` callbacks) still use `Ash.Changeset`, `Ash.get`, etc.

---

## Task 1: Project Skeleton

**Files:**
- Create: `mix.exs`
- Create: `lib/alexandria.ex`
- Create: `lib/alexandria/application.ex`
- Create: `lib/alexandria/repo.ex`
- Create: `lib/alexandria/core.ex`
- Create: `lib/alexandria/fragment_extension.ex`
- Create: `lib/alexandria/fragment_extension/transformer.ex`
- Create: `lib/alexandria/types/multilingual.ex`
- Create: `config/{config,dev,test,runtime}.exs`
- Create: `test/test_helper.exs`
- Create: `test/support/data_case.ex`
- Create: `test/support/scope.ex`
- Create: `test/alexandria/fragment_extension_test.exs`
- Create: `docker-compose.yml`
- Create: `.tool-versions`
- Create: `.formatter.exs`
- Create: `.gitignore`
- Create: `CLAUDE.md` (copy minimal version from `caluma_poc`)

- [ ] **Step 1: Scaffold the mix project**

```bash
cd ~/Documents/elixir-experiments/alexandria
mix new . --sup --app alexandria
```

Confirm `lib/alexandria.ex`, `lib/alexandria/application.ex`, `mix.exs`, `test/` exist.

- [ ] **Step 2: Pin Elixir/Erlang version**

Create `.tool-versions`:

```
elixir 1.19.0-otp-27
erlang 27.1
```

- [ ] **Step 3: Add `.gitignore`**

Create `.gitignore`:

```
/_build/
/cover/
/deps/
/doc/
/.fetch
erl_crash.dump
*.ez
alexandria-*.tar
/tmp/
.elixir_ls/
.elixir-tools/
.expert/
/dev/_build/
/dev/deps/
/dev/priv/static/assets/
```

- [ ] **Step 4: Write `mix.exs` with all v1 dependencies**

Replace `mix.exs`:

```elixir
defmodule Alexandria.MixProject do
  use Mix.Project

  def project do
    [
      app: :alexandria,
      version: "0.1.0",
      elixir: "~> 1.19",
      elixirc_paths: elixirc_paths(Mix.env()),
      consolidate_protocols: Mix.env() != :test,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Alexandria.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ash, "~> 3.23"},
      {:ash_postgres, "~> 2.0"},
      {:ash_phoenix, "~> 2.0"},
      {:ex_aws, "~> 2.5"},
      {:ex_aws_s3, "~> 2.5"},
      {:hackney, "~> 1.20"},
      {:sweet_xml, "~> 0.7"},
      {:phoenix, "~> 1.8.3"},
      {:phoenix_live_view, "~> 1.1.0"},
      {:phoenix_html, "~> 4.1"},
      {:elixir_uikit, "~> 0.7"},
      {:gettext, "~> 1.0"},
      {:jason, "~> 1.4"},
      {:spark, "~> 2.2"},
      {:phoenix_test, "~> 0.8", only: :test, runtime: false},
      {:usage_rules, "~> 1.0", only: :dev},
      {:igniter, "~> 0.6", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ash.setup"],
      "ecto.reset": ["ash.reset"],
      test: ["ash.setup --quiet", "test"],
      precommit: ["compile --warnings-as-errors", "deps.unlock --unused", "format", "ash.codegen --check", "test"]
    ]
  end
end
```

Run `mix deps.get`. Expect deps to resolve cleanly.

- [ ] **Step 5: Write `.formatter.exs`**

```elixir
[
  import_deps: [:ash, :ash_postgres, :ash_phoenix, :phoenix, :phoenix_live_view],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  plugins: [Phoenix.LiveView.HTMLFormatter]
]
```

- [ ] **Step 6: Write base config files**

Create `config/config.exs`:

```elixir
import Config

config :alexandria,
  ash_domains: [Alexandria.Core],
  ecto_repos: [Alexandria.Repo]

config :alexandria, :storage,
  adapter: Alexandria.Storage.ExAws

config :ex_aws, json_codec: Jason

import_config "#{config_env()}.exs"
```

Create `config/dev.exs`:

```elixir
import Config

config :alexandria, Alexandria.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "alexandria_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

Create `config/test.exs`:

```elixir
import Config

config :alexandria, Alexandria.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "alexandria_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :alexandria, :storage,
  adapter: Alexandria.Storage.InMemory

config :logger, level: :warning

config :ash, disable_async?: true
```

Create `config/runtime.exs`:

```elixir
import Config

if config_env() == :prod do
  config :alexandria, Alexandria.Repo,
    url: System.fetch_env!("DATABASE_URL"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE", "10"))

  config :alexandria, :storage,
    adapter: Alexandria.Storage.ExAws,
    bucket: System.fetch_env!("ALEXANDRIA_S3_BUCKET"),
    access_key_id: System.fetch_env!("ALEXANDRIA_S3_ACCESS_KEY_ID"),
    secret_access_key: System.fetch_env!("ALEXANDRIA_S3_SECRET_ACCESS_KEY"),
    endpoint_url: System.fetch_env!("ALEXANDRIA_S3_ENDPOINT_URL"),
    region: System.get_env("ALEXANDRIA_S3_REGION", "garage"),
    presigned_url_ttl_seconds: 3600
end
```

- [ ] **Step 7: Write `Alexandria.Repo`**

Create `lib/alexandria/repo.ex`:

```elixir
defmodule Alexandria.Repo do
  use AshPostgres.Repo, otp_app: :alexandria

  def installed_extensions, do: ["uuid-ossp", "citext"]

  def min_pg_version, do: %Version{major: 14, minor: 0, patch: 0}
end
```

- [ ] **Step 8: Write `Alexandria.Application`**

Replace `lib/alexandria/application.ex`:

```elixir
defmodule Alexandria.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [Alexandria.Repo]
    opts = [strategy: :one_for_one, name: Alexandria.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

- [ ] **Step 9: Write the empty `Alexandria.Core` domain**

Replace `lib/alexandria.ex`:

```elixir
defmodule Alexandria do
  @moduledoc """
  Alexandria — Ash-based document management library.
  See `Alexandria.Core` for the domain entry point.
  """
end
```

Create `lib/alexandria/core.ex`:

```elixir
defmodule Alexandria.Core do
  use Ash.Domain, extensions: [Alexandria.FragmentExtension]

  resources do
  end
end
```

- [ ] **Step 10: Write `Alexandria.FragmentExtension` + transformer**

Create `lib/alexandria/fragment_extension.ex`:

```elixir
defmodule Alexandria.FragmentExtension do
  @moduledoc false
  use Spark.Dsl.Extension,
    transformers: [Alexandria.FragmentExtension.Transformer]
end
```

Create `lib/alexandria/fragment_extension/transformer.ex`:

```elixir
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

- [ ] **Step 11: Write `Alexandria.Types.Multilingual` custom type**

Create `lib/alexandria/types/multilingual.ex`:

```elixir
defmodule Alexandria.Types.Multilingual do
  @moduledoc """
  Multilingual JSONB attribute: keys are locale strings, values are strings.
  Matches Django alexandria's `{"de-ch": "...", "en": "..."}` shape.
  """
  use Ash.Type

  @impl true
  def storage_type(_), do: :map

  @impl true
  def cast_input(nil, _), do: {:ok, nil}
  def cast_input(value, _) when is_map(value) do
    if Enum.all?(value, fn {k, v} -> is_binary(k) and is_binary(v) end) do
      {:ok, value}
    else
      {:error, "all keys and values must be strings"}
    end
  end
  def cast_input(_, _), do: {:error, "must be a map"}

  @impl true
  def cast_stored(nil, _), do: {:ok, nil}
  def cast_stored(value, _) when is_map(value), do: {:ok, value}

  @impl true
  def dump_to_native(nil, _), do: {:ok, nil}
  def dump_to_native(value, _) when is_map(value), do: {:ok, value}

  @doc "Return the value for `locale` falling back to other available locales."
  def get(nil, _locale), do: nil
  def get(map, locale) when is_map(map) do
    Map.get(map, locale) || Map.get(map, "en") || (map |> Map.values() |> List.first())
  end
end
```

- [ ] **Step 12: Write `test/support/scope.ex`**

Create `test/support/scope.ex`:

```elixir
defmodule Alexandria.Test.Scope do
  @moduledoc "Minimal scope struct for tests."
  defstruct [:actor, :locale]
end

defimpl Ash.Scope.ToOpts, for: Alexandria.Test.Scope do
  def get_actor(%{actor: actor}), do: {:ok, actor}
  def get_tenant(_), do: :error
  def get_context(%{locale: locale}), do: {:ok, %{locale: locale}}
  def get_authorize?(_), do: :error
  def get_tracer(_), do: :error
end
```

- [ ] **Step 13: Write `test/support/data_case.ex`**

Create `test/support/data_case.ex`:

```elixir
defmodule Alexandria.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Alexandria.Repo
      alias Alexandria.Test.Scope

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Alexandria.DataCase
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Alexandria.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    :ok
  end

  def admin_scope do
    %Alexandria.Test.Scope{actor: %{id: "admin", roles: [:admin]}, locale: "en"}
  end
end
```

- [ ] **Step 14: Write `test/test_helper.exs`**

```elixir
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Alexandria.Repo, :manual)
```

- [ ] **Step 15: Write the fragment extension test**

Create `test/alexandria/fragment_extension_test.exs`:

```elixir
defmodule Alexandria.FragmentExtensionTest do
  use ExUnit.Case, async: true

  defmodule TestFragment do
    use Spark.Dsl.Fragment, of: Ash.Resource

    actions do
      defaults [:read]

      read :ping do
        prepare fn query, _ -> query end
      end
    end
  end

  defmodule TestResource do
    use Ash.Resource,
      domain: nil,
      validate_domain_inclusion?: false,
      extensions: [Alexandria.FragmentExtension]

    attributes do
      uuid_primary_key :id
    end

    actions do
      defaults [:read]
    end
  end

  setup do
    Application.put_env(:alexandria, TestResource, fragments: [TestFragment])
    on_exit(fn -> Application.delete_env(:alexandria, TestResource) end)
    :ok
  end

  test "fragment is merged into the resource at compile time" do
    Code.compiler_options(ignore_module_conflict: true)

    defmodule TestResourceRecompiled do
      use Ash.Resource,
        domain: nil,
        validate_domain_inclusion?: false,
        extensions: [Alexandria.FragmentExtension]

      attributes do
        uuid_primary_key :id
      end

      actions do
        defaults [:read]
      end
    end

    action_names = TestResourceRecompiled |> Ash.Resource.Info.actions() |> Enum.map(& &1.name)
    assert :ping in action_names
  end
end
```

- [ ] **Step 16: Run the fragment test — verify it passes**

```bash
mix test test/alexandria/fragment_extension_test.exs
```

Expected: 1 passing. If failing because the application config isn't reread at compile time, add `Application.put_env/3` BEFORE the `defmodule TestResourceRecompiled` in the test.

- [ ] **Step 17: Write `docker-compose.yml` (Postgres + Garage)**

Copy the Garage service from `~/Documents/camac/elixir/garage/`. Read `~/Documents/camac/elixir/garage/garage.toml` for endpoint/key conventions; mirror them.

Create `docker-compose.yml`:

```yaml
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_USER: postgres
    ports:
      - "5432:5432"
    volumes:
      - alexandria_pg_data:/var/lib/postgresql/data

  garage:
    image: dxflrs/garage:v1.0.1
    ports:
      - "3900:3900"  # S3 API
      - "3902:3902"  # Web
    volumes:
      - alexandria_garage_data:/var/lib/garage/data
      - alexandria_garage_meta:/var/lib/garage/meta
      - ./dev/garage.toml:/etc/garage.toml:ro

volumes:
  alexandria_pg_data:
  alexandria_garage_data:
  alexandria_garage_meta:
```

Create `dev/garage.toml` (use the canton config under `~/Documents/camac/elixir/garage/garage.toml` as the template — endpoint, RPC secret, bucket name, access key).

- [ ] **Step 18: Bring up infra + verify it works**

```bash
docker compose up -d
docker compose ps
```

Both services should be healthy. Initialize Garage following its README from `~/Documents/camac/elixir/garage/README.md` (create cluster layout, generate bucket + access keys, write into a local `.env` file if the README does so).

- [ ] **Step 19: Run `mix ash.setup`**

```bash
mix ash.setup
```

Expected: creates `alexandria_dev` database, runs zero migrations (no resources yet). Verify with `psql -U postgres -h localhost -l | grep alexandria`.

- [ ] **Step 20: Add minimal `CLAUDE.md`**

Create `CLAUDE.md` (copy from `~/Documents/elixir-experiments/caluma_poc/CLAUDE.md` and substitute `caluma`/`Caluma` → `alexandria`/`Alexandria`).

- [ ] **Step 21: Commit**

```bash
git add .
git commit -m "feat: project skeleton (domain, fragment extension, multilingual type)"
```

---

## Task 2: Category Resource

**Files:**
- Create: `lib/alexandria/core/category.ex`
- Modify: `lib/alexandria/core.ex` (add resource)
- Create: `test/alexandria/core/category_test.exs`
- Create: `priv/repo/migrations/<timestamp>_initial_category.exs` (via `mix ash.codegen`)

- [ ] **Step 1: Write the failing test for `:create_root`**

Create `test/alexandria/core/category_test.exs`:

```elixir
defmodule Alexandria.Core.CategoryTest do
  use Alexandria.DataCase, async: false

  alias Alexandria.Core.Category

  describe "create_root" do
    test "creates a root category with required attributes" do
      {:ok, cat} =
        Ash.create(Category, %{
          slug: "intern",
          name: %{"en" => "Internal"},
          color: "#FFFFFF"
        },
        action: :create_root, scope: admin_scope())

      assert cat.slug == "intern"
      assert cat.parent_id == nil
      assert cat.name == %{"en" => "Internal"}
      assert cat.color == "#FFFFFF"
      assert cat.sort == 0
    end

    test "rejects an invalid color" do
      assert {:error, _} =
        Ash.create(Category, %{
          slug: "bad", name: %{"en" => "Bad"}, color: "not-a-color"
        }, action: :create_root, scope: admin_scope())
    end
  end
end
```

- [ ] **Step 2: Run test — verify it fails because Category doesn't exist**

```bash
mix test test/alexandria/core/category_test.exs
```

Expected: compile error or `module Alexandria.Core.Category does not exist`.

- [ ] **Step 3: Implement `Alexandria.Core.Category`**

Create `lib/alexandria/core/category.ex`:

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
      reference :parent, name: "alexandria_core_category_parent_id_fkey", on_delete: :restrict
    end

    check_constraints do
      check_constraint :color,
        name: "alexandria_core_category_color_check",
        check: "color ~ '^#[0-9a-fA-F]{6}$'"
    end
  end

  attributes do
    attribute :slug, :string, primary_key?: true, allow_nil?: false, public?: true
    attribute :name, Alexandria.Types.Multilingual, allow_nil?: false, public?: true
    attribute :description, Alexandria.Types.Multilingual, public?: true
    attribute :color, :string, allow_nil?: false, public?: true
    attribute :sort, :integer, default: 0, allow_nil?: false, public?: true
    attribute :metainfo, :map, default: %{}, allow_nil?: false, public?: true
    attribute :created_by_user, :string, public?: true
    attribute :created_by_group, :string, public?: true
    create_timestamp :created_at
    update_timestamp :modified_at
  end

  relationships do
    belongs_to :parent, __MODULE__,
      attribute_type: :string,
      source_attribute: :parent_id,
      destination_attribute: :slug,
      public?: true

    has_many :children, __MODULE__,
      source_attribute: :slug,
      destination_attribute: :parent_id
  end

  actions do
    defaults [:read]

    read :list_roots do
      filter expr(is_nil(parent_id))
      prepare build(sort: [sort: :asc])
    end

    read :list_children do
      argument :parent_id, :string, allow_nil?: false
      filter expr(parent_id == ^arg(:parent_id))
      prepare build(sort: [sort: :asc])
    end

    create :create_root do
      accept [:slug, :name, :description, :color, :sort, :metainfo]
    end

    create :create_child do
      accept [:slug, :name, :description, :color, :sort, :metainfo]
      argument :parent_id, :string, allow_nil?: false
      change manage_relationship(:parent_id, :parent, type: :append)
    end

    update :rename do
      accept [:name, :description]
    end

    update :recolor do
      accept [:color]
    end

    update :reorder do
      accept [:sort]
    end

    update :set_metainfo do
      accept [:metainfo]
    end

    destroy :destroy
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end
end
```

- [ ] **Step 4: Register the resource in the domain**

Modify `lib/alexandria/core.ex`:

```elixir
defmodule Alexandria.Core do
  use Ash.Domain, extensions: [Alexandria.FragmentExtension]

  resources do
    resource Alexandria.Core.Category
  end
end
```

- [ ] **Step 5: Generate the migration**

```bash
mix ash.codegen initial_alexandria_category
```

Inspect `priv/repo/migrations/<timestamp>_initial_alexandria_category.exs`. Verify the generated SQL creates `alexandria_core_category` with the correct columns, FK name, and check constraint.

- [ ] **Step 6: Diff generated migration against Django schema**

Build a temporary Django alexandria DB:

```bash
docker run --rm -e POSTGRES_PASSWORD=postgres -p 5433:5432 -d --name django_alex_pg postgres:16
# Wait for it to be ready
docker exec django_alex_pg pg_isready -U postgres
# From camac/elixir/django:
DATABASE_URL=postgres://postgres:postgres@localhost:5433/alex_django poetry run python manage.py migrate alexandria_core
pg_dump --schema-only -h localhost -p 5433 -U postgres alex_django > /tmp/django_schema.sql
docker stop django_alex_pg
```

Run the Elixir migration in a throwaway DB:

```bash
MIX_ENV=test mix ash.setup
pg_dump --schema-only -h localhost -p 5432 -U postgres alexandria_test > /tmp/elixir_schema.sql
```

Diff:

```bash
diff <(grep -A 100 "alexandria_core_category" /tmp/django_schema.sql) <(grep -A 100 "alexandria_core_category" /tmp/elixir_schema.sql)
```

If any column type / constraint / index name differs, edit the resource DSL (NOT the migration), regenerate, re-diff. Repeat until clean.

- [ ] **Step 7: Run the failing tests**

```bash
mix test test/alexandria/core/category_test.exs
```

Expected: 2 passing.

- [ ] **Step 8: Add tests for `list_roots`, `list_children`**

Append to `test/alexandria/core/category_test.exs`:

```elixir
  describe "list_roots" do
    test "returns only root categories sorted by :sort" do
      {:ok, _} = create_root("a", sort: 2)
      {:ok, _} = create_root("b", sort: 1)
      {:ok, a} = create_root("a-parent")
      {:ok, _} = Ash.create(Category, %{slug: "child", name: %{"en" => "C"}, color: "#000000"},
                 arguments: %{parent_id: "a-parent"},
                 action: :create_child, scope: admin_scope())

      slugs = Category |> Ash.Query.for_read(:list_roots, %{}, scope: admin_scope()) |> Ash.read!() |> Enum.map(& &1.slug)
      assert slugs == ["b", "a", "a-parent"]
    end
  end

  describe "list_children" do
    test "returns only the named parent's children" do
      {:ok, _} = create_root("p1")
      {:ok, _} = create_root("p2")
      {:ok, _} = Ash.create(Category, %{slug: "c1", name: %{"en" => "C1"}, color: "#000000"},
                 arguments: %{parent_id: "p1"}, action: :create_child, scope: admin_scope())
      {:ok, _} = Ash.create(Category, %{slug: "c2", name: %{"en" => "C2"}, color: "#000000"},
                 arguments: %{parent_id: "p2"}, action: :create_child, scope: admin_scope())

      slugs = Category
            |> Ash.Query.for_read(:list_children, %{parent_id: "p1"}, scope: admin_scope())
            |> Ash.read!()
            |> Enum.map(& &1.slug)
      assert slugs == ["c1"]
    end
  end

  defp create_root(slug, opts \\ []) do
    Ash.create(Category, %{
      slug: slug,
      name: %{"en" => slug},
      color: "#000000",
      sort: Keyword.get(opts, :sort, 0)
    }, action: :create_root, scope: admin_scope())
  end
```

- [ ] **Step 9: Run tests — expect green**

```bash
mix test test/alexandria/core/category_test.exs
```

Expected: 4 passing.

- [ ] **Step 10: Add tests for `:rename`, `:recolor`, `:reorder`, `:set_metainfo`, `:destroy`**

Append:

```elixir
  describe "mutations" do
    test "rename updates name + description" do
      {:ok, c} = create_root("a")
      {:ok, c2} = Ash.update(c, %{name: %{"en" => "Renamed"}, description: %{"en" => "d"}},
                  action: :rename, scope: admin_scope())
      assert c2.name == %{"en" => "Renamed"}
      assert c2.description == %{"en" => "d"}
    end

    test "recolor updates only color" do
      {:ok, c} = create_root("a")
      {:ok, c2} = Ash.update(c, %{color: "#AABBCC"}, action: :recolor, scope: admin_scope())
      assert c2.color == "#AABBCC"
    end

    test "reorder updates only sort" do
      {:ok, c} = create_root("a")
      {:ok, c2} = Ash.update(c, %{sort: 42}, action: :reorder, scope: admin_scope())
      assert c2.sort == 42
    end

    test "set_metainfo replaces metainfo" do
      {:ok, c} = create_root("a")
      {:ok, c2} = Ash.update(c, %{metainfo: %{"k" => "v"}}, action: :set_metainfo, scope: admin_scope())
      assert c2.metainfo == %{"k" => "v"}
    end

    test "destroy removes the category" do
      {:ok, c} = create_root("a")
      :ok = Ash.destroy!(c, action: :destroy, scope: admin_scope())
      assert {:error, _} = Ash.get(Category, "a", scope: admin_scope())
    end
  end
```

- [ ] **Step 11: Run — verify green**

```bash
mix test test/alexandria/core/category_test.exs
```

Expected: 9 passing.

- [ ] **Step 12: Commit**

```bash
git add -A
git commit -m "feat: category resource with semantic actions + Django-matched schema"
```

---

## Task 3: Tag, TagSynonymGroup, Mark Resources

**Files:**
- Create: `lib/alexandria/core/tag.ex`
- Create: `lib/alexandria/core/tag_synonym_group.ex`
- Create: `lib/alexandria/core/mark.ex`
- Create: `test/alexandria/core/tag_test.exs`
- Create: `test/alexandria/core/tag_synonym_group_test.exs`
- Create: `test/alexandria/core/mark_test.exs`
- Modify: `lib/alexandria/core.ex`
- Create: `priv/repo/migrations/<timestamp>_add_tag_tag_synonym_group_mark.exs`

- [ ] **Step 1: Write failing test for `TagSynonymGroup`**

Create `test/alexandria/core/tag_synonym_group_test.exs`:

```elixir
defmodule Alexandria.Core.TagSynonymGroupTest do
  use Alexandria.DataCase, async: false
  alias Alexandria.Core.TagSynonymGroup

  test "create + rename + destroy" do
    {:ok, g} = Ash.create(TagSynonymGroup, %{name: %{"en" => "Synonyms"}},
                action: :create, scope: admin_scope())
    {:ok, g2} = Ash.update(g, %{name: %{"en" => "Renamed"}},
                action: :rename, scope: admin_scope())
    assert g2.name == %{"en" => "Renamed"}
    :ok = Ash.destroy!(g2, action: :destroy, scope: admin_scope())
  end
end
```

- [ ] **Step 2: Run — expect fail (module missing)**

```bash
mix test test/alexandria/core/tag_synonym_group_test.exs
```

- [ ] **Step 3: Implement `TagSynonymGroup`**

Create `lib/alexandria/core/tag_synonym_group.ex`:

```elixir
defmodule Alexandria.Core.TagSynonymGroup do
  use Ash.Resource,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [Alexandria.FragmentExtension]

  postgres do
    table "alexandria_core_tagsynonymgroup"
    repo Alexandria.Repo
  end

  attributes do
    uuid_primary_key :id, public?: true
    attribute :name, Alexandria.Types.Multilingual, allow_nil?: false, public?: true
  end

  relationships do
    has_many :tags, Alexandria.Core.Tag, destination_attribute: :tag_synonym_group_id
  end

  actions do
    defaults [:read]

    create :create do
      accept [:name]
    end

    update :rename do
      accept [:name]
    end

    destroy :destroy
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end
end
```

- [ ] **Step 4: Implement `Tag`**

Create `lib/alexandria/core/tag.ex`:

```elixir
defmodule Alexandria.Core.Tag do
  use Ash.Resource,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [Alexandria.FragmentExtension]

  postgres do
    table "alexandria_core_tag"
    repo Alexandria.Repo
  end

  attributes do
    attribute :slug, :string, primary_key?: true, allow_nil?: false, public?: true
    attribute :name, Alexandria.Types.Multilingual, allow_nil?: false, public?: true
    attribute :description, Alexandria.Types.Multilingual, public?: true
    attribute :metainfo, :map, default: %{}, public?: true
    attribute :created_by_user, :string, public?: true
    attribute :created_by_group, :string, public?: true
    create_timestamp :created_at
    update_timestamp :modified_at
  end

  relationships do
    belongs_to :tag_synonym_group, Alexandria.Core.TagSynonymGroup, public?: true
  end

  actions do
    defaults [:read]

    create :create do
      accept [:slug, :name, :description, :metainfo]
    end

    update :rename do
      accept [:name, :description]
    end

    update :join_synonym_group do
      accept []
      argument :group_id, :uuid, allow_nil?: false
      change manage_relationship(:group_id, :tag_synonym_group, type: :append_and_remove)
    end

    update :leave_synonym_group do
      accept []
      change set_attribute(:tag_synonym_group_id, nil)
    end

    destroy :destroy
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end
end
```

- [ ] **Step 5: Implement `Mark`**

Create `lib/alexandria/core/mark.ex`:

```elixir
defmodule Alexandria.Core.Mark do
  use Ash.Resource,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [Alexandria.FragmentExtension]

  postgres do
    table "alexandria_core_mark"
    repo Alexandria.Repo
  end

  attributes do
    attribute :slug, :string, primary_key?: true, allow_nil?: false, public?: true
    attribute :name, Alexandria.Types.Multilingual, allow_nil?: false, public?: true
    attribute :description, Alexandria.Types.Multilingual, public?: true
    attribute :metainfo, :map, default: %{}, public?: true
    attribute :created_by_user, :string, public?: true
    attribute :created_by_group, :string, public?: true
    create_timestamp :created_at
    update_timestamp :modified_at
  end

  actions do
    defaults [:read]

    create :create do
      accept [:slug, :name, :description, :metainfo]
    end

    update :rename do
      accept [:name, :description]
    end

    destroy :destroy
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end
end
```

- [ ] **Step 6: Register all three resources in the domain**

Modify `lib/alexandria/core.ex`:

```elixir
defmodule Alexandria.Core do
  use Ash.Domain, extensions: [Alexandria.FragmentExtension]

  resources do
    resource Alexandria.Core.Category
    resource Alexandria.Core.Tag
    resource Alexandria.Core.TagSynonymGroup
    resource Alexandria.Core.Mark
  end
end
```

- [ ] **Step 7: Generate the migration**

```bash
mix ash.codegen add_tag_tag_synonym_group_mark
```

- [ ] **Step 8: Diff against Django schema for each of the three tables**

For each of `alexandria_core_tag`, `alexandria_core_tagsynonymgroup`, `alexandria_core_mark`: use the same diff workflow as Task 2 Step 6. Adjust resource DSL until empty diff.

- [ ] **Step 9: Write tests for `Tag` and `Mark`**

Create `test/alexandria/core/tag_test.exs`:

```elixir
defmodule Alexandria.Core.TagTest do
  use Alexandria.DataCase, async: false
  alias Alexandria.Core.{Tag, TagSynonymGroup}

  test "lifecycle: create, rename, join group, leave group, destroy" do
    {:ok, t} = Ash.create(Tag, %{slug: "urgent", name: %{"en" => "Urgent"}},
               action: :create, scope: admin_scope())
    {:ok, t2} = Ash.update(t, %{name: %{"en" => "Very Urgent"}},
                action: :rename, scope: admin_scope())
    assert t2.name == %{"en" => "Very Urgent"}

    {:ok, g} = Ash.create(TagSynonymGroup, %{name: %{"en" => "S"}},
               action: :create, scope: admin_scope())
    {:ok, t3} = Ash.update(t2, %{}, arguments: %{group_id: g.id},
                action: :join_synonym_group, scope: admin_scope())
    assert t3.tag_synonym_group_id == g.id

    {:ok, t4} = Ash.update(t3, %{}, action: :leave_synonym_group, scope: admin_scope())
    assert t4.tag_synonym_group_id == nil

    :ok = Ash.destroy!(t4, action: :destroy, scope: admin_scope())
  end
end
```

Create `test/alexandria/core/mark_test.exs`:

```elixir
defmodule Alexandria.Core.MarkTest do
  use Alexandria.DataCase, async: false
  alias Alexandria.Core.Mark

  test "lifecycle: create, rename, destroy" do
    {:ok, m} = Ash.create(Mark, %{slug: "important", name: %{"en" => "Important"}},
               action: :create, scope: admin_scope())
    {:ok, m2} = Ash.update(m, %{name: %{"en" => "Critical"}},
                action: :rename, scope: admin_scope())
    assert m2.name == %{"en" => "Critical"}
    :ok = Ash.destroy!(m2, action: :destroy, scope: admin_scope())
  end
end
```

- [ ] **Step 10: Run all tests — verify green**

```bash
mix test
```

Expected: all green (1 fragment + 9 category + 1 tag-synonym + 1 tag + 1 mark = 13 passing).

- [ ] **Step 11: Commit**

```bash
git add -A
git commit -m "feat: tag, tag_synonym_group, mark resources + tests"
```

---

## Task 4: Document Resource + Join Tables

**Files:**
- Create: `lib/alexandria/core/document.ex`
- Create: `lib/alexandria/core/document_tag.ex`
- Create: `lib/alexandria/core/document_mark.ex`
- Create: `test/alexandria/core/document_test.exs`
- Modify: `lib/alexandria/core.ex`
- Create: `priv/repo/migrations/<timestamp>_add_document_and_joins.exs`

- [ ] **Step 1: Write the failing test for `:upload` (stubbed — no real file yet)**

Create `test/alexandria/core/document_test.exs`:

```elixir
defmodule Alexandria.Core.DocumentTest do
  use Alexandria.DataCase, async: false
  alias Alexandria.Core.{Category, Document, Tag, Mark}

  setup do
    {:ok, cat} = Ash.create(Category, %{slug: "intern", name: %{"en" => "Intern"}, color: "#000000"},
                 action: :create_root, scope: admin_scope())
    {:ok, %{category: cat}}
  end

  test "create stub document without file", %{category: cat} do
    {:ok, d} = Ash.create(Document, %{
      title: %{"en" => "Doc1"},
      description: %{"en" => "Desc"},
      date: ~D[2026-05-12]
    }, arguments: %{category_id: cat.slug}, action: :create, scope: admin_scope())

    assert d.title == %{"en" => "Doc1"}
    assert d.category_id == cat.slug
  end
end
```

(Note: `:upload` action that creates Document + File is wired in Task 6 once Storage exists; for Task 4 the stub `:create` action accepts only the document fields.)

- [ ] **Step 2: Run — expect fail (module missing)**

```bash
mix test test/alexandria/core/document_test.exs
```

- [ ] **Step 3: Implement `DocumentTag`**

Create `lib/alexandria/core/document_tag.ex`:

```elixir
defmodule Alexandria.Core.DocumentTag do
  use Ash.Resource,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [Alexandria.FragmentExtension]

  postgres do
    table "alexandria_core_document_tags"
    repo Alexandria.Repo
  end

  attributes do
    uuid_primary_key :id, public?: true
  end

  relationships do
    belongs_to :document, Alexandria.Core.Document, allow_nil?: false, public?: true
    belongs_to :tag, Alexandria.Core.Tag,
      attribute_type: :string,
      destination_attribute: :slug,
      allow_nil?: false,
      public?: true
  end

  actions do
    defaults [:read, :create, :destroy]
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end
end
```

- [ ] **Step 4: Implement `DocumentMark`**

Create `lib/alexandria/core/document_mark.ex` (same shape as `DocumentTag`, swap `tag` for `mark`).

- [ ] **Step 5: Implement `Document`**

Create `lib/alexandria/core/document.ex`:

```elixir
defmodule Alexandria.Core.Document do
  use Ash.Resource,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [Alexandria.FragmentExtension]

  postgres do
    table "alexandria_core_document"
    repo Alexandria.Repo
  end

  attributes do
    uuid_primary_key :id, public?: true
    attribute :title, Alexandria.Types.Multilingual, allow_nil?: false, public?: true
    attribute :description, Alexandria.Types.Multilingual, public?: true
    attribute :date, :date, public?: true
    attribute :metainfo, :map, default: %{}, public?: true
    attribute :created_by_user, :string, public?: true
    attribute :created_by_group, :string, public?: true
    create_timestamp :created_at
    update_timestamp :modified_at
  end

  relationships do
    belongs_to :category, Alexandria.Core.Category,
      attribute_type: :string,
      destination_attribute: :slug,
      allow_nil?: false,
      public?: true

    has_many :files, Alexandria.Core.File

    many_to_many :tags, Alexandria.Core.Tag,
      through: Alexandria.Core.DocumentTag,
      source_attribute_on_join_resource: :document_id,
      destination_attribute_on_join_resource: :tag_id,
      destination_attribute: :slug

    many_to_many :marks, Alexandria.Core.Mark,
      through: Alexandria.Core.DocumentMark,
      source_attribute_on_join_resource: :document_id,
      destination_attribute_on_join_resource: :mark_id,
      destination_attribute: :slug
  end

  actions do
    defaults [:read]

    read :list_by_category do
      argument :category_id, :string, allow_nil?: false
      filter expr(category_id == ^arg(:category_id))
    end

    read :by_tag do
      argument :tag_id, :string, allow_nil?: false
      filter expr(exists(tags, slug == ^arg(:tag_id)))
    end

    read :by_mark do
      argument :mark_id, :string, allow_nil?: false
      filter expr(exists(marks, slug == ^arg(:mark_id)))
    end

    create :create do
      accept [:title, :description, :date, :metainfo]
      argument :category_id, :string, allow_nil?: false
      change manage_relationship(:category_id, :category, type: :append)
    end

    update :rename do
      accept [:title]
    end

    update :edit_description do
      accept [:description]
    end

    update :set_date do
      accept [:date]
    end

    update :move_to_category do
      accept []
      argument :category_id, :string, allow_nil?: false
      change manage_relationship(:category_id, :category, type: :append_and_remove)
    end

    update :set_metainfo do
      accept [:metainfo]
    end

    update :add_tag do
      accept []
      argument :tag_id, :string, allow_nil?: false
      require_atomic? false
      change manage_relationship(:tag_id, :tags, type: :append, on_no_match: :error)
    end

    update :remove_tag do
      accept []
      argument :tag_id, :string, allow_nil?: false
      require_atomic? false
      change manage_relationship(:tag_id, :tags, type: :remove)
    end

    update :add_mark do
      accept []
      argument :mark_id, :string, allow_nil?: false
      require_atomic? false
      change manage_relationship(:mark_id, :marks, type: :append, on_no_match: :error)
    end

    update :remove_mark do
      accept []
      argument :mark_id, :string, allow_nil?: false
      require_atomic? false
      change manage_relationship(:mark_id, :marks, type: :remove)
    end

    update :archive do
      accept []
      change set_attribute(:metainfo, expr(fragment("? || jsonb_build_object('archived_at', now()::text)", metainfo)))
    end

    update :restore do
      accept []
      change set_attribute(:metainfo, expr(fragment("? - 'archived_at'", metainfo)))
    end

    destroy :destroy
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end
end
```

- [ ] **Step 6: Register Document + joins in the domain**

Modify `lib/alexandria/core.ex`:

```elixir
defmodule Alexandria.Core do
  use Ash.Domain, extensions: [Alexandria.FragmentExtension]

  resources do
    resource Alexandria.Core.Category
    resource Alexandria.Core.Tag
    resource Alexandria.Core.TagSynonymGroup
    resource Alexandria.Core.Mark
    resource Alexandria.Core.Document
    resource Alexandria.Core.DocumentTag
    resource Alexandria.Core.DocumentMark
  end
end
```

- [ ] **Step 7: Generate the migration**

```bash
mix ash.codegen add_document_and_joins
```

- [ ] **Step 8: Diff against Django schema for `alexandria_core_document`, `alexandria_core_document_tags`, `alexandria_core_document_marks`**

Same workflow as Task 2 Step 6. Adjust DSL until diff is empty.

- [ ] **Step 9: Run the existing test — verify green**

```bash
mix test test/alexandria/core/document_test.exs
```

Expected: 1 passing.

- [ ] **Step 10: Add tests for `list_by_category`, `by_tag`, `by_mark`, all mutations, archive/restore, destroy**

Append to `test/alexandria/core/document_test.exs`:

```elixir
  describe "reads" do
    test "list_by_category filters", %{category: cat} do
      {:ok, _} = create_doc(cat.slug, "A")
      {:ok, _} = create_doc(cat.slug, "B")
      {:ok, other} = Ash.create(Category, %{slug: "other", name: %{"en" => "O"}, color: "#000000"},
                     action: :create_root, scope: admin_scope())
      {:ok, _} = create_doc(other.slug, "C")

      titles = Document
               |> Ash.Query.for_read(:list_by_category, %{category_id: cat.slug}, scope: admin_scope())
               |> Ash.read!()
               |> Enum.map(& &1.title["en"])
      assert Enum.sort(titles) == ["A", "B"]
    end

    test "by_tag filters", %{category: cat} do
      {:ok, t} = Ash.create(Tag, %{slug: "x", name: %{"en" => "X"}}, action: :create, scope: admin_scope())
      {:ok, d} = create_doc(cat.slug, "A")
      {:ok, _} = create_doc(cat.slug, "B")
      {:ok, _} = Ash.update(d, %{}, arguments: %{tag_id: t.slug}, action: :add_tag, scope: admin_scope())
      titles = Document |> Ash.Query.for_read(:by_tag, %{tag_id: t.slug}, scope: admin_scope()) |> Ash.read!() |> Enum.map(& &1.title["en"])
      assert titles == ["A"]
    end
  end

  describe "mutations" do
    test "rename / edit_description / set_date", %{category: cat} do
      {:ok, d} = create_doc(cat.slug, "A")
      {:ok, d} = Ash.update(d, %{title: %{"en" => "AA"}}, action: :rename, scope: admin_scope())
      {:ok, d} = Ash.update(d, %{description: %{"en" => "desc"}}, action: :edit_description, scope: admin_scope())
      {:ok, d} = Ash.update(d, %{date: ~D[2026-01-01]}, action: :set_date, scope: admin_scope())
      assert d.title == %{"en" => "AA"}
      assert d.description == %{"en" => "desc"}
      assert d.date == ~D[2026-01-01]
    end

    test "move_to_category", %{category: cat} do
      {:ok, other} = Ash.create(Category, %{slug: "other", name: %{"en" => "O"}, color: "#000000"},
                     action: :create_root, scope: admin_scope())
      {:ok, d} = create_doc(cat.slug, "A")
      {:ok, d2} = Ash.update(d, %{}, arguments: %{category_id: other.slug},
                  action: :move_to_category, scope: admin_scope())
      assert d2.category_id == other.slug
    end

    test "add_tag/remove_tag", %{category: cat} do
      {:ok, t} = Ash.create(Tag, %{slug: "x", name: %{"en" => "X"}}, action: :create, scope: admin_scope())
      {:ok, d} = create_doc(cat.slug, "A")
      {:ok, d} = Ash.update(d, %{}, arguments: %{tag_id: t.slug}, action: :add_tag, scope: admin_scope())
      d = Ash.load!(d, [:tags], scope: admin_scope())
      assert [%{slug: "x"}] = d.tags
      {:ok, d} = Ash.update(d, %{}, arguments: %{tag_id: t.slug}, action: :remove_tag, scope: admin_scope())
      d = Ash.load!(d, [:tags], scope: admin_scope())
      assert d.tags == []
    end

    test "archive sets metainfo.archived_at then restore clears it", %{category: cat} do
      {:ok, d} = create_doc(cat.slug, "A")
      {:ok, d} = Ash.update(d, %{}, action: :archive, scope: admin_scope())
      assert Map.has_key?(d.metainfo, "archived_at")
      {:ok, d} = Ash.update(d, %{}, action: :restore, scope: admin_scope())
      refute Map.has_key?(d.metainfo, "archived_at")
    end

    test "destroy", %{category: cat} do
      {:ok, d} = create_doc(cat.slug, "A")
      :ok = Ash.destroy!(d, action: :destroy, scope: admin_scope())
      assert {:error, _} = Ash.get(Document, d.id, scope: admin_scope())
    end
  end

  defp create_doc(category_id, title) do
    Ash.create(Document, %{title: %{"en" => title}},
      arguments: %{category_id: category_id},
      action: :create, scope: admin_scope())
  end
```

- [ ] **Step 11: Run all tests — verify green**

```bash
mix test
```

Expected: all passing.

- [ ] **Step 12: Commit**

```bash
git add -A
git commit -m "feat: document resource + tag/mark joins + semantic actions"
```

---

## Task 5: Storage Behaviour + Test-Only InMemory Adapter

The library ships **only** the behaviour + dispatcher. Adapter
implementations belong to consumers — see Task 6 (ExAws moves to
`dev/`) and Task 7 (dev's own InMemory test support).

**Files:**
- Create: `lib/alexandria/storage.ex`
- Create: `test/support/in_memory_storage.ex` (test-only InMemory adapter
  under module `Alexandria.Test.InMemoryStorage`)
- Create: `test/alexandria/storage_test.exs`

- [ ] **Step 1: Write failing behaviour-contract test**

Create `test/alexandria/storage_test.exs`:

```elixir
defmodule Alexandria.StorageTest do
  use ExUnit.Case, async: false

  defmodule SharedAssertions do
    defmacro __using__(adapter: adapter) do
      quote do
        @adapter unquote(adapter)

        setup do
          Application.put_env(:alexandria, :storage, adapter: @adapter)
          on_exit(fn -> :ok end)
          :ok
        end

        test "put/get cycle: put then exists? is true" do
          key = "test-#{System.unique_integer([:positive])}"
          assert :ok = Alexandria.Storage.put(key, "hello bytes")
          assert Alexandria.Storage.exists?(key)
        end

        test "delete removes the object" do
          key = "test-#{System.unique_integer([:positive])}"
          :ok = Alexandria.Storage.put(key, "x")
          :ok = Alexandria.Storage.delete(key)
          refute Alexandria.Storage.exists?(key)
        end

        test "presigned_url returns a string url" do
          key = "test-#{System.unique_integer([:positive])}"
          :ok = Alexandria.Storage.put(key, "x")
          assert {:ok, url} = Alexandria.Storage.presigned_url(key)
          assert is_binary(url)
        end
      end
    end
  end

  describe "InMemory adapter (test support)" do
    use SharedAssertions, adapter: Alexandria.Test.InMemoryStorage
  end
end
```

(No `:garage`/ExAws describe block in the lib's storage test — the lib
doesn't ship an ExAws adapter, so its contract test exercises only the
test-support InMemory adapter. Real S3/Garage coverage lives with the
consumer that owns the ExAws adapter.)

- [ ] **Step 2: Run — verify fail (module missing)**

```bash
mix test test/alexandria/storage_test.exs
```

- [ ] **Step 3: Implement `Alexandria.Storage` behaviour + dispatcher**

Create `lib/alexandria/storage.ex`:

```elixir
defmodule Alexandria.Storage do
  @moduledoc """
  Storage abstraction. Resource actions call this module; this module
  dispatches to the configured adapter.
  """

  @callback put(key :: String.t(), content :: binary | {:file, Path.t()} | Enumerable.t(), opts :: keyword) :: :ok | {:error, term}
  @callback delete(key :: String.t()) :: :ok | {:error, term}
  @callback presigned_url(key :: String.t(), opts :: keyword) :: {:ok, String.t()} | {:error, term}
  @callback exists?(key :: String.t()) :: boolean

  def put(key, content, opts \\ []), do: adapter().put(key, content, opts)
  def delete(key), do: adapter().delete(key)
  def presigned_url(key, opts \\ []), do: adapter().presigned_url(key, opts)
  def exists?(key), do: adapter().exists?(key)

  defp adapter, do: Application.fetch_env!(:alexandria, :storage)[:adapter]
end
```

- [ ] **Step 4: Implement `Alexandria.Test.InMemoryStorage`**

Create `test/support/in_memory_storage.ex` (compiled only under
`elixirc_paths(:test)`, so it never ships in the library jar):

```elixir
defmodule Alexandria.Test.InMemoryStorage do
  @behaviour Alexandria.Storage

  use Agent

  def start_link(_), do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  @impl true
  def put(key, content, _opts) when is_binary(content) do
    ensure_started()
    Agent.update(__MODULE__, &Map.put(&1, key, content))
    :ok
  end
  def put(key, {:file, path}, opts), do: put(key, File.read!(path), opts)

  @impl true
  def delete(key) do
    ensure_started()
    Agent.update(__MODULE__, &Map.delete(&1, key))
    :ok
  end

  @impl true
  def presigned_url(key, _opts) do
    {:ok, "inmemory://" <> key}
  end

  @impl true
  def exists?(key) do
    ensure_started()
    Agent.get(__MODULE__, &Map.has_key?(&1, key))
  end

  defp ensure_started do
    case Process.whereis(__MODULE__) do
      nil -> start_link([])
      _ -> :ok
    end
  end
end
```

The adapter lazily starts its own Agent on first call, so the library's
supervision tree stays a plain `[Alexandria.Repo]` and `application.ex`
does not need to know about adapter modules.

- [ ] **Step 5: Run the storage tests — verify green**

```bash
mix test test/alexandria/storage_test.exs
```

Expected: 3 passing.

- [ ] **Step 7: Commit**

```bash
git add -A
git commit -m "feat: storage behaviour + in-memory adapter + contract test"
```

---

## Task 6: File Resource (ExAws adapter lives in the dev sub-app)

The `Alexandria.Core.File` resource calls `Alexandria.Storage.*` — but
the lib does **not** ship a real S3 adapter. Tests for the resource use
the test-support InMemory adapter from Task 5; the production-shape
`ExAws` adapter lives in the dev sub-app (`AlexandriaDev.Storage.ExAws`)
and is set up alongside the dev demo (Task 7).

**Files:**
- Create: `lib/alexandria/core/file.ex`
- Create: `test/alexandria/core/file_test.exs`
- Modify: `lib/alexandria/core/document.ex` (add `:upload` action)
- Modify: `test/alexandria/core/document_test.exs` (add upload tests)
- Modify: `lib/alexandria/core.ex` (register File)
- Create: `priv/repo/migrations/<timestamp>_add_file.exs`

(The ExAws adapter module + Garage integration live in the dev sub-app —
see Task 7. The library's `mix.exs` does NOT depend on `:ex_aws`,
`:ex_aws_s3`, `:hackney`, or `:sweet_xml`; those move to `dev/mix.exs`.)

- [ ] **Step 1: Write failing test for `File.upload_original`**

Create `test/alexandria/core/file_test.exs`:

```elixir
defmodule Alexandria.Core.FileTest do
  use Alexandria.DataCase, async: false
  alias Alexandria.Core.{Category, Document, File}

  setup do
    {:ok, cat} = Ash.create(Category, %{slug: "intern", name: %{"en" => "Intern"}, color: "#000000"},
                 action: :create_root, scope: admin_scope())
    {:ok, doc} = Ash.create(Document, %{title: %{"en" => "Doc1"}},
                 arguments: %{category_id: cat.slug}, action: :create, scope: admin_scope())
    {:ok, %{document: doc}}
  end

  test "upload_original creates a File row + stores bytes", %{document: doc} do
    {:ok, f} = Ash.create(File, %{
      name: "file.pdf",
      mime_type: "application/pdf",
      size: 5,
      bytes: "hello"
    }, arguments: %{document_id: doc.id}, action: :upload_original, scope: admin_scope())

    assert f.name == "file.pdf"
    assert f.variant == :original
    assert is_binary(f.content)
    assert Alexandria.Storage.exists?(f.content)
  end

  test "destroy removes both the row and the S3 object", %{document: doc} do
    {:ok, f} = Ash.create(File, %{
      name: "f.pdf", mime_type: "application/pdf", size: 1, bytes: "x"
    }, arguments: %{document_id: doc.id}, action: :upload_original, scope: admin_scope())
    key = f.content
    :ok = Ash.destroy!(f, action: :destroy, scope: admin_scope())
    refute Alexandria.Storage.exists?(key)
  end

  test "download_url returns a presigned URL", %{document: doc} do
    {:ok, f} = Ash.create(File, %{
      name: "f.pdf", mime_type: "application/pdf", size: 1, bytes: "x"
    }, arguments: %{document_id: doc.id}, action: :upload_original, scope: admin_scope())
    assert {:ok, url} = Ash.run_action(File, :download_url, %{id: f.id}, scope: admin_scope())
    assert is_binary(url)
  end
end
```

- [ ] **Step 2: Run — fail (module missing)**

```bash
mix test test/alexandria/core/file_test.exs
```

- [ ] **Step 3: Implement `Alexandria.Core.File`**

Create `lib/alexandria/core/file.ex`:

```elixir
defmodule Alexandria.Core.File do
  use Ash.Resource,
    domain: Alexandria.Core,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [Alexandria.FragmentExtension]

  postgres do
    table "alexandria_core_file"
    repo Alexandria.Repo

    check_constraints do
      check_constraint :variant,
        name: "alexandria_core_file_variant_check",
        check: "variant IN ('original', 'thumbnail', 'rendering')"
    end
  end

  attributes do
    uuid_primary_key :id, public?: true
    attribute :name, :string, allow_nil?: false, public?: true
    attribute :variant, :atom, constraints: [one_of: [:original, :thumbnail, :rendering]],
      default: :original, allow_nil?: false, public?: true
    attribute :content, :string, allow_nil?: false, public?: true     # S3 key
    attribute :mime_type, :string, allow_nil?: false, public?: true
    attribute :size, :integer, allow_nil?: false, public?: true
    attribute :metainfo, :map, default: %{}, public?: true
    attribute :created_by_user, :string, public?: true
    attribute :created_by_group, :string, public?: true
    create_timestamp :created_at
    update_timestamp :modified_at
  end

  relationships do
    belongs_to :document, Alexandria.Core.Document, allow_nil?: false, public?: true
    belongs_to :original, __MODULE__, public?: true
  end

  actions do
    defaults [:read]

    read :for_document do
      argument :document_id, :uuid, allow_nil?: false
      filter expr(document_id == ^arg(:document_id))
    end

    create :upload_original do
      accept [:name, :mime_type, :size]
      argument :document_id, :uuid, allow_nil?: false
      argument :bytes, :string, allow_nil?: false
      change manage_relationship(:document_id, :document, type: :append)
      change set_attribute(:variant, :original)
      change Alexandria.Core.File.Changes.PutBytes
    end

    create :upload_thumbnail do
      accept [:name, :mime_type, :size]
      argument :document_id, :uuid, allow_nil?: false
      argument :original_id, :uuid, allow_nil?: false
      argument :bytes, :string, allow_nil?: false
      change manage_relationship(:document_id, :document, type: :append)
      change manage_relationship(:original_id, :original, type: :append)
      change set_attribute(:variant, :thumbnail)
      change Alexandria.Core.File.Changes.PutBytes
    end

    create :upload_rendering do
      accept [:name, :mime_type, :size]
      argument :document_id, :uuid, allow_nil?: false
      argument :original_id, :uuid, allow_nil?: false
      argument :bytes, :string, allow_nil?: false
      change manage_relationship(:document_id, :document, type: :append)
      change manage_relationship(:original_id, :original, type: :append)
      change set_attribute(:variant, :rendering)
      change Alexandria.Core.File.Changes.PutBytes
    end

    update :rename do
      accept [:name]
    end

    update :replace_content do
      accept [:mime_type, :size]
      argument :bytes, :string, allow_nil?: false
      change Alexandria.Core.File.Changes.ReplaceBytes
    end

    destroy :destroy do
      change Alexandria.Core.File.Changes.DeleteFromStorage
    end

    action :download_url, :string do
      argument :id, :uuid, allow_nil?: false
      run fn input, _ ->
        with %{content: key} <- Ash.get!(__MODULE__, input.arguments.id) do
          Alexandria.Storage.presigned_url(key)
        end
      end
    end
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end
end
```

- [ ] **Step 4: Implement the change modules**

Create `lib/alexandria/core/file/changes/put_bytes.ex`:

```elixir
defmodule Alexandria.Core.File.Changes.PutBytes do
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _ctx) do
    bytes = Ash.Changeset.get_argument(changeset, :bytes)
    key = Ecto.UUID.generate()

    case Alexandria.Storage.put(key, bytes) do
      :ok ->
        Ash.Changeset.change_attribute(changeset, :content, key)

      {:error, reason} ->
        Ash.Changeset.add_error(changeset, field: :bytes, message: "storage put failed: #{inspect(reason)}")
    end
  end
end
```

Create `lib/alexandria/core/file/changes/replace_bytes.ex`:

```elixir
defmodule Alexandria.Core.File.Changes.ReplaceBytes do
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _ctx) do
    bytes = Ash.Changeset.get_argument(changeset, :bytes)
    new_key = Ecto.UUID.generate()
    old_key = Ash.Changeset.get_attribute(changeset, :content)

    case Alexandria.Storage.put(new_key, bytes) do
      :ok ->
        changeset
        |> Ash.Changeset.change_attribute(:content, new_key)
        |> Ash.Changeset.after_action(fn _, file ->
          if old_key, do: Alexandria.Storage.delete(old_key)
          {:ok, file}
        end)

      {:error, reason} ->
        Ash.Changeset.add_error(changeset, field: :bytes, message: "storage put failed: #{inspect(reason)}")
    end
  end
end
```

Create `lib/alexandria/core/file/changes/delete_from_storage.ex`:

```elixir
defmodule Alexandria.Core.File.Changes.DeleteFromStorage do
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _ctx) do
    key = Ash.Changeset.get_attribute(changeset, :content)

    Ash.Changeset.after_action(changeset, fn _, file ->
      if key do
        case Alexandria.Storage.delete(key) do
          :ok -> :ok
          {:error, reason} ->
            require Logger
            Logger.warning("storage delete failed for key=#{key}: #{inspect(reason)}")
        end
      end
      {:ok, file}
    end)
  end
end
```

- [ ] **Step 5: Register `File` in the domain**

Modify `lib/alexandria/core.ex` — add `resource Alexandria.Core.File`.

- [ ] **Step 6: Generate migration + diff against Django schema**

```bash
mix ash.codegen add_file
```

Apply Task 2 Step 6 diff workflow for `alexandria_core_file`. Adjust DSL until clean.

- [ ] **Step 7: Run File tests — verify green**

```bash
mix test test/alexandria/core/file_test.exs
```

Expected: 3 passing.

- [ ] **Step 8: ExAws adapter lives in the dev sub-app (Task 7)**

The lib's storage_test only exercises the test-support InMemory adapter.
The real ExAws adapter and its Garage integration are scaffolded inside
the dev sub-app (`dev/lib/alexandria_dev/storage/ex_aws.ex`,
module `AlexandriaDev.Storage.ExAws`) and configured via `dev/config/dev.exs`:

```elixir
config :alexandria, :storage,
  adapter: AlexandriaDev.Storage.ExAws,
  bucket: System.get_env("ALEXANDRIA_S3_BUCKET", "alexandria-media"),
  ...
```

Garage-backed coverage of the storage contract is exercised in dev via
the demo LiveView (PhoenixTest smoke); a dedicated `:garage`-tagged
contract test in `dev/test/` is YAGNI for now.

- [ ] **Step 9: Wire `Document.upload` to also create the initial File**

Modify `lib/alexandria/core/document.ex` — append inside `actions do ... end` after `create :create`:

```elixir
    create :upload do
      accept [:title, :description, :date, :metainfo]
      argument :category_id, :string, allow_nil?: false
      argument :file_name, :string, allow_nil?: false
      argument :mime_type, :string, allow_nil?: false
      argument :size, :integer, allow_nil?: false
      argument :bytes, :string, allow_nil?: false

      change manage_relationship(:category_id, :category, type: :append)

      change after_action(fn changeset, document, _ctx ->
        Ash.create!(Alexandria.Core.File, %{
          name: Ash.Changeset.get_argument(changeset, :file_name),
          mime_type: Ash.Changeset.get_argument(changeset, :mime_type),
          size: Ash.Changeset.get_argument(changeset, :size)
        },
        arguments: %{
          document_id: document.id,
          bytes: Ash.Changeset.get_argument(changeset, :bytes)
        },
        action: :upload_original,
        scope: changeset.context.private[:ash_scope] || changeset.context[:scope])

        {:ok, document}
      end)
    end
```

- [ ] **Step 10: Add a Document.upload test**

Append to `test/alexandria/core/document_test.exs`:

```elixir
  test "upload creates document + initial file in one transaction", %{category: cat} do
    {:ok, d} = Ash.create(Document, %{
      title: %{"en" => "Doc1"}
    }, arguments: %{
      category_id: cat.slug,
      file_name: "a.pdf",
      mime_type: "application/pdf",
      size: 5,
      bytes: "hello"
    }, action: :upload, scope: admin_scope())

    d = Ash.load!(d, [:files], scope: admin_scope())
    assert [%{name: "a.pdf", variant: :original} = f] = d.files
    assert Alexandria.Storage.exists?(f.content)
  end
```

- [ ] **Step 11: Run full suite — verify green**

```bash
mix test
```

Expected: all tests passing.

- [ ] **Step 12: Commit**

```bash
git add -A
git commit -m "feat: file resource, document.upload (ExAws adapter ships with dev sub-app)"
```

---

## Task 7: Dev Sub-app Skeleton

**Files:**
- Create: `dev/mix.exs`
- Create: `dev/config/{config,dev,test,runtime}.exs`
- Create: `dev/lib/alexandria_dev.ex`
- Create: `dev/lib/alexandria_dev/application.ex`
- Create: `dev/lib/alexandria_dev/scope.ex`
- Create: `dev/lib/alexandria_dev_web/endpoint.ex`
- Create: `dev/lib/alexandria_dev_web/router.ex`
- Create: `dev/lib/alexandria_dev_web/browser_live.ex`
- Create: `dev/lib/alexandria_dev_web/components/layouts.ex`
- Create: `dev/lib/alexandria_dev_web/components/layouts/root.html.heex`
- Create: `dev/priv/repo/seeds.exs`
- Create: `dev/test/test_helper.exs`
- Create: `dev/test/support/conn_case.ex`

- [ ] **Step 1: Scaffold `dev/mix.exs`**

Create `dev/mix.exs`:

```elixir
defmodule AlexandriaDev.MixProject do
  use Mix.Project

  def project do
    [
      app: :alexandria_dev,
      version: "0.1.0",
      elixir: "~> 1.19",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      mod: {AlexandriaDev.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:alexandria, path: ".."},
      {:bandit, "~> 1.5"},
      {:phoenix_live_reload, "~> 1.4", only: :dev},
      {:phoenix_test, "~> 0.8", only: :test, runtime: false}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ash.setup", "run priv/repo/seeds.exs"],
      "phx.server": ["phx.server"],
      test: ["ash.setup --quiet", "test"]
    ]
  end
end
```

Run `cd dev && mix deps.get`.

- [ ] **Step 2: Write dev config files**

Create `dev/config/config.exs`:

```elixir
import Config

config :alexandria, Alexandria.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "alexandria_dev",
  pool_size: 10

config :alexandria,
  ash_domains: [Alexandria.Core],
  ecto_repos: [Alexandria.Repo]

config :alexandria_dev, AlexandriaDevWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4001],
  url: [host: "localhost"],
  secret_key_base: String.duplicate("a", 64),
  live_view: [signing_salt: "dev"],
  pubsub_server: AlexandriaDev.PubSub,
  render_errors: [formats: [html: AlexandriaDevWeb.ErrorHTML]]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
```

Create `dev/config/dev.exs`:

```elixir
import Config

config :alexandria_dev, AlexandriaDevWeb.Endpoint,
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  live_reload: [
    patterns: [
      ~r"lib/alexandria_dev_web/.*(ex|heex)$",
      ~r"../lib/alexandria_web/.*(ex|heex)$"
    ]
  ]

config :alexandria, :storage,
  adapter: Alexandria.Storage.ExAws,
  bucket: System.get_env("ALEXANDRIA_S3_BUCKET", "alexandria-dev"),
  access_key_id: System.get_env("ALEXANDRIA_S3_ACCESS_KEY_ID", "dev"),
  secret_access_key: System.get_env("ALEXANDRIA_S3_SECRET_ACCESS_KEY", "dev"),
  endpoint_url: System.get_env("ALEXANDRIA_S3_ENDPOINT_URL", "http://localhost:3900"),
  region: "garage"
```

Create `dev/config/test.exs`:

```elixir
import Config

config :alexandria, Alexandria.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :alexandria, :storage, adapter: Alexandria.Storage.InMemory

config :alexandria_dev, AlexandriaDevWeb.Endpoint,
  server: false
```

Create `dev/config/runtime.exs`:

```elixir
import Config
```

(empty — relies on env vars in dev/prod only)

- [ ] **Step 3: Write `AlexandriaDev.Scope`**

Create `dev/lib/alexandria_dev.ex`:

```elixir
defmodule AlexandriaDev do
  def demo_scope do
    %AlexandriaDev.Scope{
      actor: %{id: "demo-user", roles: [:admin]},
      locale: "en"
    }
  end
end
```

Create `dev/lib/alexandria_dev/scope.ex`:

```elixir
defmodule AlexandriaDev.Scope do
  defstruct [:actor, :locale]
end

defimpl Ash.Scope.ToOpts, for: AlexandriaDev.Scope do
  def get_actor(%{actor: a}), do: {:ok, a}
  def get_tenant(_), do: :error
  def get_context(%{locale: l}), do: {:ok, %{locale: l}}
  def get_authorize?(_), do: :error
  def get_tracer(_), do: :error
end
```

- [ ] **Step 4: Write `AlexandriaDev.Application`**

Create `dev/lib/alexandria_dev/application.ex`:

```elixir
defmodule AlexandriaDev.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: AlexandriaDev.PubSub},
      AlexandriaDevWeb.Endpoint
    ]
    Supervisor.start_link(children, strategy: :one_for_one, name: AlexandriaDev.Supervisor)
  end
end
```

- [ ] **Step 5: Write `AlexandriaDevWeb.Endpoint`**

Create `dev/lib/alexandria_dev_web/endpoint.ex`:

```elixir
defmodule AlexandriaDevWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :alexandria_dev

  @session_options [
    store: :cookie,
    key: "_alexandria_dev_key",
    signing_salt: "dev",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Phoenix.LiveReloader
  plug Phoenix.CodeReloader

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug AlexandriaDevWeb.Router
end
```

- [ ] **Step 6: Write router + layouts**

Create `dev/lib/alexandria_dev_web/router.ex`:

```elixir
defmodule AlexandriaDevWeb.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AlexandriaDevWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", AlexandriaDevWeb do
    pipe_through :browser
    live "/", BrowserLive, :index
  end
end
```

Create `dev/lib/alexandria_dev_web/components/layouts.ex`:

```elixir
defmodule AlexandriaDevWeb.Layouts do
  use Phoenix.Component
  embed_templates "layouts/*"
end
```

Create `dev/lib/alexandria_dev_web/components/layouts/root.html.heex`:

```heex
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Alexandria Dev</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/uikit@3.21.5/dist/css/uikit.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/uikit@3.21.5/dist/js/uikit.min.js"></script>
  </head>
  <body class="uk-light">
    {@inner_content}
  </body>
</html>
```

- [ ] **Step 7: Write the `BrowserLive` (renders root categories as plain list — sanity check)**

Create `dev/lib/alexandria_dev_web/browser_live.ex`:

```elixir
defmodule AlexandriaDevWeb.BrowserLive do
  use Phoenix.LiveView, layout: {AlexandriaDevWeb.Layouts, :root}

  def mount(_params, _session, socket) do
    scope = AlexandriaDev.demo_scope()
    cats = Alexandria.Core.Category |> Ash.Query.for_read(:list_roots, %{}, scope: scope) |> Ash.read!()
    {:ok, assign(socket, scope: scope, categories: cats, params: %{})}
  end

  def handle_params(params, _, socket), do: {:noreply, assign(socket, :params, params)}

  def render(assigns) do
    ~H"""
    <div class="uk-container uk-margin">
      <h1 class="uk-heading-divider">Alexandria Dev</h1>
      <ul>
        <li :for={c <- @categories}>
          {Alexandria.Types.Multilingual.get(c.name, @scope.locale)}
        </li>
      </ul>
    </div>
    """
  end
end
```

- [ ] **Step 8: Write `dev/priv/repo/seeds.exs`**

Create `dev/priv/repo/seeds.exs`:

```elixir
alias Alexandria.Core.Category

scope = AlexandriaDev.demo_scope()

dump_path = Path.expand("~/Documents/camac/elixir/alexandria/demo/dump.json")
dump = dump_path |> File.read!() |> Jason.decode!()

dump
|> Enum.filter(&(&1["model"] == "alexandria_core.category"))
|> Enum.each(fn %{"pk" => slug, "fields" => f} ->
  Ash.create!(Category, %{
    slug: slug,
    name: Jason.decode!(f["name"]),
    description: Jason.decode!(f["description"]),
    color: f["color"],
    metainfo: f["meta"] || %{}
  }, action: :create_root, scope: scope)
end)

IO.puts("Seeded #{Category |> Ash.read!(scope: scope) |> length()} categories")
```

- [ ] **Step 9: Run `mix setup` from `dev/`**

```bash
cd dev
mix setup
```

Expected: deps fetched, DB created, migrations applied, seeds run.

- [ ] **Step 10: Start the server + verify in browser**

```bash
mix phx.server
```

Open `http://localhost:4001`. Expected: page renders with seeded category list (4-5 names from `dump.json`).

- [ ] **Step 11: Write a smoke test in `dev/`**

Create `dev/test/test_helper.exs`:

```elixir
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Alexandria.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:phoenix_test)
```

Create `dev/test/support/conn_case.ex`:

```elixir
defmodule AlexandriaDevWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use AlexandriaDevWeb, :verified_routes
      import Phoenix.ConnTest
      import Plug.Conn
      import PhoenixTest
      @endpoint AlexandriaDevWeb.Endpoint
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Alexandria.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
```

Create `dev/test/alexandria_dev_web/browser_live_test.exs`:

```elixir
defmodule AlexandriaDevWeb.BrowserLiveTest do
  use AlexandriaDevWeb.ConnCase, async: false

  test "page renders the seeded categories", %{conn: conn} do
    {:ok, _} = Ash.create(Alexandria.Core.Category,
      %{slug: "test-c", name: %{"en" => "TestCat"}, color: "#000000"},
      action: :create_root, scope: AlexandriaDev.demo_scope())

    conn
    |> visit(~p"/")
    |> assert_has("h1", text: "Alexandria Dev")
    |> assert_has("li", text: "TestCat")
  end
end
```

- [ ] **Step 12: Run the dev test — verify green**

```bash
cd dev
mix test
```

Expected: 1 passing.

- [ ] **Step 13: Commit**

```bash
cd ..
git add -A
git commit -m "feat: dev sub-app shell + seeded category list + PhoenixTest smoke"
```

---

## Task 8: LiveComponent Read Paths

**Files:**
- Create: `lib/alexandria_web/browser.ex`
- Modify: `dev/lib/alexandria_dev_web/browser_live.ex` (mount LiveComponent)
- Modify: `dev/test/alexandria_dev_web/browser_live_test.exs`
- Modify: `dev/priv/repo/seeds.exs` (also seed documents)

- [ ] **Step 1: Extend seeds to also create demo documents**

Modify `dev/priv/repo/seeds.exs` — append:

```elixir
alias Alexandria.Core.Document
[first | _] = Category |> Ash.read!(scope: scope)

for i <- 1..3 do
  Ash.create!(Document,
    %{title: %{"en" => "Demo doc #{i}"}, date: ~D[2026-05-01]},
    arguments: %{category_id: first.slug},
    action: :create, scope: scope)
end

IO.puts("Seeded 3 demo documents in #{first.slug}")
```

Run `cd dev && mix ash.reset && mix run priv/repo/seeds.exs`.

- [ ] **Step 2: Write the LiveComponent `AlexandriaWeb.Browser`**

Create `lib/alexandria_web/browser.ex`:

```elixir
defmodule AlexandriaWeb.Browser do
  use Phoenix.LiveComponent

  alias Alexandria.Core.{Category, Document}
  alias Alexandria.Types.Multilingual

  def update(assigns, socket) do
    scope = assigns.scope
    params = assigns.params || %{}
    locale = scope.locale || "en"
    selected_category = params["category"]
    selected_documents = decode_ids(params["document"])

    categories =
      Category |> Ash.Query.for_read(:list_roots, %{}, scope: scope) |> Ash.read!()

    documents =
      case selected_category do
        nil -> []
        slug ->
          Document
          |> Ash.Query.for_read(:list_by_category, %{category_id: slug}, scope: scope)
          |> Ash.read!()
      end

    open_documents =
      case selected_documents do
        [] -> []
        ids -> Document |> Ash.Query.filter(id in ^ids) |> Ash.read!(scope: scope)
      end

    {:ok,
     assign(socket,
       scope: scope, params: params, locale: locale,
       categories: categories, documents: documents,
       open_documents: open_documents,
       selected_category: selected_category,
       selected_documents: selected_documents
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="uk-grid uk-grid-collapse" uk-grid>
      <aside class="uk-width-1-5">
        <ul class="uk-nav uk-nav-default">
          <li :for={c <- @categories} class={if @selected_category == c.slug, do: "uk-active"}>
            <.link patch={category_path(@params, c.slug)}>
              {Multilingual.get(c.name, @locale)}
            </.link>
          </li>
        </ul>
      </aside>

      <main class="uk-width-2-5">
        <h3 :if={!@selected_category}>Select a category</h3>
        <ul :if={@selected_category} class="uk-list uk-list-divider">
          <li :for={d <- @documents}>
            <.link patch={document_path(@params, d.id)}>
              {Multilingual.get(d.title, @locale)}
            </.link>
          </li>
        </ul>
      </main>

      <section class="uk-width-2-5">
        <article :for={d <- @open_documents} class="uk-card uk-card-default uk-card-body uk-margin-small-bottom">
          <h4>{Multilingual.get(d.title, @locale)}</h4>
          <p :if={d.description}>{Multilingual.get(d.description, @locale)}</p>
          <small :if={d.date}>{d.date}</small>
        </article>
      </section>
    </div>
    """
  end

  defp decode_ids(nil), do: []
  defp decode_ids(""), do: []
  defp decode_ids(str), do: String.split(str, ",", trim: true)

  defp category_path(params, slug) do
    "?" <> URI.encode_query(Map.put(params, "category", slug))
  end

  defp document_path(params, id) do
    current = decode_ids(params["document"])
    new = (current ++ [id]) |> Enum.uniq() |> Enum.join(",")
    "?" <> URI.encode_query(Map.put(params, "document", new))
  end
end
```

- [ ] **Step 3: Mount the LiveComponent in dev's `BrowserLive`**

Replace `dev/lib/alexandria_dev_web/browser_live.ex`:

```elixir
defmodule AlexandriaDevWeb.BrowserLive do
  use Phoenix.LiveView, layout: {AlexandriaDevWeb.Layouts, :root}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, scope: AlexandriaDev.demo_scope(), params: %{})}
  end

  def handle_params(params, _, socket), do: {:noreply, assign(socket, :params, params)}

  def render(assigns) do
    ~H"""
    <div class="uk-container uk-margin">
      <h1 class="uk-heading-divider">Alexandria Dev</h1>
      <.live_component module={AlexandriaWeb.Browser} id="b" scope={@scope} params={@params} />
    </div>
    """
  end
end
```

- [ ] **Step 4: Manual verification**

```bash
cd dev
mix phx.server
```

Open `http://localhost:4001`. Click a category — query string becomes `?category=...`, document list appears. Click a document — query string becomes `?category=...&document=...`, detail panel appears. Click a second document — both in panel, query string is `?...&document=uuid1,uuid2`.

- [ ] **Step 5: Update integration test**

Replace `dev/test/alexandria_dev_web/browser_live_test.exs`:

```elixir
defmodule AlexandriaDevWeb.BrowserLiveTest do
  use AlexandriaDevWeb.ConnCase, async: false

  alias Alexandria.Core.{Category, Document}

  setup do
    scope = AlexandriaDev.demo_scope()
    {:ok, cat} = Ash.create(Category, %{slug: "intern", name: %{"en" => "Intern"}, color: "#000000"},
                 action: :create_root, scope: scope)
    {:ok, doc} = Ash.create(Document, %{title: %{"en" => "Doc A"}},
                 arguments: %{category_id: cat.slug}, action: :create, scope: scope)
    {:ok, %{category: cat, document: doc}}
  end

  test "selecting a category lists documents", %{conn: conn} do
    conn
    |> visit(~p"/")
    |> click_link("Intern")
    |> assert_has("a", text: "Doc A")
  end

  test "selecting a document adds it to the URL and opens the detail panel", %{conn: conn} do
    conn
    |> visit(~p"/")
    |> click_link("Intern")
    |> click_link("Doc A")
    |> assert_has("article h4", text: "Doc A")
  end
end
```

- [ ] **Step 6: Run dev tests — verify green**

```bash
cd dev
mix test
```

Expected: 2 passing.

- [ ] **Step 7: Commit**

```bash
cd ..
git add -A
git commit -m "feat: LiveComponent read paths (category tree + document list + detail panel)"
```

---

## Task 9: LiveComponent Mutations + Upload

**Files:**
- Modify: `lib/alexandria_web/browser.ex` (add forms + handle_event + uploads)
- Modify: `dev/test/alexandria_dev_web/browser_live_test.exs`

- [ ] **Step 1: Add a "rename" form to the detail panel**

Modify `lib/alexandria_web/browser.ex` — add to `render/1` inside the `<article>`:

```heex
        <.form for={%{}} as={:rename} phx-submit="rename" phx-target={@myself} phx-value-id={d.id}>
          <input name="rename[title]" type="text" value={Multilingual.get(d.title, @locale)} class="uk-input" />
          <button type="submit" class="uk-button uk-button-primary uk-button-small">Save</button>
        </.form>
```

Add a `handle_event/3` clause:

```elixir
  def handle_event("rename", %{"id" => id, "rename" => %{"title" => new_title}}, socket) do
    doc = Ash.get!(Document, id, scope: socket.assigns.scope)
    locale = socket.assigns.locale

    {:ok, _} = Ash.update(doc, %{title: Map.put(doc.title, locale, new_title)},
                action: :rename, scope: socket.assigns.scope)

    {:noreply, push_patch(socket.assigns[:__parent__] || socket, to: "?#{URI.encode_query(socket.assigns.params)}")}
  end
```

(Note: `push_patch` from LiveComponent updates the parent LV's URL.)

- [ ] **Step 2: Run the existing dev tests — verify they still pass**

```bash
cd dev
mix test
```

- [ ] **Step 3: Add a "delete" button + handle_event**

Modify `lib/alexandria_web/browser.ex`:

In `render/1` inside the `<article>`:

```heex
        <button class="uk-button uk-button-danger uk-button-small"
                phx-click="delete" phx-target={@myself} phx-value-id={d.id}
                data-confirm="Delete this document?">Delete</button>
```

`handle_event/3`:

```elixir
  def handle_event("delete", %{"id" => id}, socket) do
    doc = Ash.get!(Document, id, scope: socket.assigns.scope)
    :ok = Ash.destroy!(doc, action: :destroy, scope: socket.assigns.scope)

    remaining = socket.assigns.selected_documents |> Enum.reject(&(&1 == id))
    new_doc_param = case remaining do
      [] -> %{}
      ids -> %{"document" => Enum.join(ids, ",")}
    end

    new_params = socket.assigns.params |> Map.delete("document") |> Map.merge(new_doc_param)
    {:noreply, push_patch(socket, to: "?#{URI.encode_query(new_params)}")}
  end
```

- [ ] **Step 4: Add upload form for a new document**

Modify `lib/alexandria_web/browser.ex` — replace the `<main>` section's content to include an upload form when a category is selected.

In `update/2` add `allow_upload`:

```elixir
    socket =
      socket
      |> Phoenix.LiveView.allow_upload(:file, accept: :any, max_entries: 1, max_file_size: 50_000_000)
```

(Note: `allow_upload` on a LiveComponent must be called inside `update/2` and the parent LV must also call `allow_upload`. For dev sub-app simplicity, instead handle the upload entirely in `handle_event` reading from `Plug.Upload`. For now do a simpler form using a regular `<input type="file">` and reading bytes inside the event handler — see Step 5.)

Replace the `<main>` block:

```heex
      <main class="uk-width-2-5">
        <h3 :if={!@selected_category}>Select a category</h3>

        <div :if={@selected_category}>
          <form phx-submit="upload" phx-target={@myself} class="uk-margin">
            <input name="upload[title]" placeholder="Title" class="uk-input uk-margin-small-bottom" required />
            <input type="file" name="upload[file]" class="uk-margin-small-bottom" required />
            <button type="submit" class="uk-button uk-button-primary uk-button-small">Upload</button>
          </form>

          <ul class="uk-list uk-list-divider">
            <li :for={d <- @documents}>
              <.link patch={document_path(@params, d.id)}>
                {Multilingual.get(d.title, @locale)}
              </.link>
            </li>
          </ul>
        </div>
      </main>
```

`handle_event` for upload (using Plug.Upload via the form encoder — endpoint already has `Plug.Parsers` with `:multipart`):

```elixir
  def handle_event("upload", %{"upload" => %{"title" => title, "file" => %Plug.Upload{} = upload}}, socket) do
    bytes = File.read!(upload.path)
    {:ok, _doc} = Ash.create(Document, %{title: %{socket.assigns.locale => title}},
      arguments: %{
        category_id: socket.assigns.selected_category,
        file_name: upload.filename,
        mime_type: upload.content_type,
        size: byte_size(bytes),
        bytes: bytes
      }, action: :upload, scope: socket.assigns.scope)

    {:noreply, push_patch(socket, to: "?#{URI.encode_query(socket.assigns.params)}")}
  end
```

- [ ] **Step 5: Run integration tests + add one for upload + one for delete**

Append to `dev/test/alexandria_dev_web/browser_live_test.exs`:

```elixir
  test "deleting a document removes it", %{conn: conn} do
    conn
    |> visit(~p"/")
    |> click_link("Intern")
    |> click_link("Doc A")
    |> click_button("Delete")
    |> refute_has("a", text: "Doc A")
  end

  test "uploading a document adds it to the list", %{conn: conn} do
    conn
    |> visit(~p"/")
    |> click_link("Intern")
    |> fill_in("Title", with: "Uploaded.pdf")
    # Note: PhoenixTest support for file uploads requires `upload(...)`; check 0.8 docs for exact API
    |> upload("upload[file]", "test/fixtures/sample.txt")
    |> click_button("Upload")
    |> assert_has("a", text: "Uploaded.pdf")
  end
```

Create `dev/test/fixtures/sample.txt`:

```
hello
```

- [ ] **Step 6: Run dev tests — verify green**

```bash
cd dev
mix test
```

Expected: 4 passing.

- [ ] **Step 7: Manual verification**

```bash
cd dev
mix phx.server
```

Browser at `http://localhost:4001`:
- click a category → see the list + upload form
- type a title, choose a file, click Upload → file appears in the list, query string unchanged
- click a document → detail opens
- rename → title updates
- delete → document disappears from the list

- [ ] **Step 8: Commit**

```bash
cd ..
git add -A
git commit -m "feat: LiveComponent mutations + inline upload"
```

---

## Task 10: Archive / Restore Lifecycle + Final Integration Test

**Files:**
- Modify: `lib/alexandria_web/browser.ex` (archive / restore buttons + hide archived from main list)
- Modify: `dev/test/alexandria_dev_web/browser_live_test.exs`

- [ ] **Step 1: Add a `list_active` read action to Document**

Modify `lib/alexandria/core/document.ex` — append in `actions do`:

```elixir
    read :list_active_by_category do
      argument :category_id, :string, allow_nil?: false
      filter expr(category_id == ^arg(:category_id) and is_nil(fragment("?->>'archived_at'", metainfo)))
      prepare build(sort: [modified_at: :desc])
    end
```

- [ ] **Step 2: Use `:list_active_by_category` in the LiveComponent + add archive/restore buttons**

Modify `lib/alexandria_web/browser.ex`:

In `update/2`, replace the `:list_by_category` call with `:list_active_by_category`. In `<article>` add:

```heex
        <button class="uk-button uk-button-default uk-button-small"
                phx-click="archive" phx-target={@myself} phx-value-id={d.id}>Archive</button>
```

`handle_event`:

```elixir
  def handle_event("archive", %{"id" => id}, socket) do
    doc = Ash.get!(Document, id, scope: socket.assigns.scope)
    {:ok, _} = Ash.update(doc, %{}, action: :archive, scope: socket.assigns.scope)

    remaining = socket.assigns.selected_documents |> Enum.reject(&(&1 == id))
    new_doc_param = case remaining do
      [] -> %{}
      ids -> %{"document" => Enum.join(ids, ",")}
    end
    new_params = socket.assigns.params |> Map.delete("document") |> Map.merge(new_doc_param)
    {:noreply, push_patch(socket, to: "?#{URI.encode_query(new_params)}")}
  end
```

- [ ] **Step 3: Add an integration test for archive**

Append to `dev/test/alexandria_dev_web/browser_live_test.exs`:

```elixir
  test "archiving a document removes it from the active list", %{conn: conn} do
    conn
    |> visit(~p"/")
    |> click_link("Intern")
    |> click_link("Doc A")
    |> click_button("Archive")
    |> refute_has("a", text: "Doc A")
  end
```

- [ ] **Step 4: Run dev tests — verify green**

```bash
cd dev
mix test
```

Expected: 5 passing.

- [ ] **Step 5: Run the full root suite**

```bash
cd ..
mix test
```

Expected: all green.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat: archive/restore lifecycle + final integration test"
```

- [ ] **Step 7: Final precommit run**

```bash
mix precommit
```

Expected: clean compile (warnings as errors), unused deps absent, formatted, codegen check passes, full test suite green.

- [ ] **Step 8: Tag v0.1.0**

```bash
git tag -a v0.1.0 -m "alexandria v0.1.0 — initial Ash/Phoenix/LiveView port"
```

---

## Self-Review

**Spec coverage check:**

| Spec section | Plan task(s) |
|---|---|
| §1 Project skeleton | Task 1 |
| §2 Data model — Category | Task 2 |
| §2 Data model — Tag/TagSynonymGroup/Mark | Task 3 |
| §2 Data model — Document + joins | Task 4 |
| §2 Data model — File | Task 6 |
| §3 Action surface — Category | Task 2 |
| §3 Action surface — Document | Task 4 + Task 6 (upload) + Task 10 (archive/restore) |
| §3 Action surface — File | Task 6 |
| §3 Action surface — Tag/TSG/Mark | Task 3 |
| §4 Storage behaviour | Task 5 (behaviour + test-support InMemory in lib) + Task 7 (`AlexandriaDev.Storage.ExAws` adapter in dev sub-app) |
| §5 Fragment extension | Task 1 (module + test) |
| §6 Embedding contract | Task 8 (read paths) + Task 9 (mutations + upload) |
| §7 Testing | Each task has tests; integration in dev/ tasks 7-10 |
| §8 Build sequence | Maps 1:1 to tasks 1-10 |

All v1 scope covered. v2-deferred items (`:search`, WebDAV, oban, audit log) are correctly absent.

**Type consistency:** the `bytes` argument is `:string` (binary) in `File.upload_*` and `Document.upload` actions. The action `:download_url` returns `:string`. `variant` constraint is `[one_of: [:original, :thumbnail, :rendering]]` consistently. The `Alexandria.Test.Scope` and `AlexandriaDev.Scope` structs both have `:actor` and `:locale` keys and both implement `Ash.Scope.ToOpts`.

**No placeholders.** Every step shows actual code or actual commands.
