# Alexandria

Document-management backend ported from Django alexandria to Elixir/Ash.

- `lib/alexandria/` — the library: Ash domain `Alexandria.Core` with resources
  `Category`, `Tag`, `Mark`, `Document`, `File`, `TagSynonymGroup`. Persists to
  Postgres via `AshPostgres`. No web layer.
- `dev/` — a Phoenix 1.8 / LiveView 1.1 harness app that depends on
  `alexandria` as a path dep. Used to play with the library in a browser. Not
  the production app.
- `docker-compose.yml` — Postgres 16 + Garage (S3-compatible blob store) for
  local dev.

## Prerequisites

- `asdf` with Elixir 1.19 / OTP 27 (see `.tool-versions`)
- Docker (for Postgres; Garage only needed for file uploads)

## Setup

```bash
asdf install
docker compose up -d postgres
cd dev
mix setup        # deps.get + esbuild/sass install + ash.setup + seeds
mix phx.server   # http://localhost:4001
```

`mix setup` runs `dev/priv/repo/seeds.exs`, which inserts four root categories
plus three demo documents. The seed is idempotent — re-running skips when
categories already exist.

To wipe and reseed:

```bash
cd dev
mix ash.reset
mix run priv/repo/seeds.exs
```

## Tests

```bash
cd dev && mix test          # web + integration
mix test                    # (from repo root) library-only
```

## Layout

```
lib/alexandria/core/        Ash resources (Category, Document, ...)
lib/alexandria/types/       Custom Ash types (e.g. Multilingual JSONB)
dev/lib/alexandria_dev_web/ Phoenix endpoint, router, LiveView, components
dev/assets/                 esbuild + dart_sass entry points; UIkit shim
```

The `Alexandria.Core` domain (`lib/alexandria/core.ex`) lists every resource
action and its public function name — read it first to find the API surface.
All actions take a `scope:` option; use `AlexandriaDev.demo_scope/0` from IEx
or LiveView mounts during development.

## IEx

```bash
cd dev && iex -S mix
```

```elixir
scope = AlexandriaDev.demo_scope()
Alexandria.Core.list_root_categories!(scope: scope)
```

## Agent docs

`CLAUDE.md` is for AI agents working in this repo; it points at
`mix usage_rules.search_docs` for looking up Ash / Phoenix APIs. Humans can
use the same command — it's faster than browsing hexdocs.
