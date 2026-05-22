# Training Tasks

Hands-on tasks to learn Phoenix LiveView and Ash inside this project.

## Getting Started

1. Install runtime via [asdf](https://asdf-vm.com/). Add the plugins once,
   then let asdf read `.tool-versions`:

   ```bash
   asdf plugin add erlang
   asdf plugin add elixir
   asdf install
   ```

2. Start Postgres (and the Garage S3 server) from the repo root:

   ```bash
   docker compose up -d
   ```

3. Install deps, create the DB and seed demo data:

   ```bash
   mix setup
   ```

4. Start the dev server and open <http://localhost:4001>:

   ```bash
   mix phx.server
   ```

5. Useful while learning:
   - `iex -S mix phx.server` — server with an IEx shell attached
   - `mix test` — run the test suite
   - `mix usage_rules.search_docs <query>` — search docs for any installed dep

## Tasks

Work through these in order. Each builds on the previous one.

1. **Load categories from the database** and render them in the category nav
   (`lib/alexandria_dev_web/components/browser/category_nav.ex`).
2. **Show description and document count** for each category.
3. **Make categories clickable** and mark the clicked one as active in the nav.
4. **Extract the document row** in `document_list.ex` into its own function
   component. The current file ships with a single example row — your job is
   to move it into a `document_row/1` component and render a list of rows.
