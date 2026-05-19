defmodule Mix.Tasks.Alexandria.Install.Docs do
  @moduledoc false

  def short_doc do
    "Installs Alexandria - scaffolds the consumer-owned domain and resource modules."
  end

  def example do
    "mix alexandria.install"
  end

  def long_doc do
    """
    #{short_doc()}

    Alexandria ships Spark DSL extensions that inject the Alexandria
    document/category/tag/etc shape into consumer-owned Ash resources.
    This installer scaffolds the 8 resource modules and a domain so the
    consumer can immediately start customizing.

    ## Example

    ```bash
    #{example()}
    ```

    With a custom namespace:

    ```bash
    mix alexandria.install --module MyApp.Library
    ```

    ## Options

      * `--module` (`-m`) - The module namespace for the generated domain
        and resources. Defaults to `<App>.Core`. The 8 resources are
        scaffolded as `<namespace>.{Category, Document, DocumentMark,
        DocumentTag, File, Mark, Tag, TagSynonymGroup}`.
      * `--yes` (`-y`) - Skip interactive prompts.
    """
  end
end

if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.Alexandria.Install do
    @shortdoc "#{__MODULE__.Docs.short_doc()}"

    @moduledoc __MODULE__.Docs.long_doc()

    use Igniter.Mix.Task

    @impl Igniter.Mix.Task
    def info(_argv, _composing_task) do
      %Igniter.Mix.Task.Info{
        group: :alexandria,
        adds_deps: [],
        installs: [],
        example: __MODULE__.Docs.example(),
        only: nil,
        positional: [],
        composes: ["ash_postgres.install"],
        schema: [
          module: :string,
          yes: :boolean
        ],
        defaults: [],
        aliases: [
          m: :module,
          y: :yes
        ],
        required: []
      }
    end

    @impl Igniter.Mix.Task
    def igniter(igniter) do
      otp_app = Igniter.Project.Application.app_name(igniter)

      domain =
        case igniter.args.options[:module] do
          nil ->
            Igniter.Project.Module.module_name(igniter, "Core")

          override when is_binary(override) ->
            Igniter.Project.Module.parse(override)
        end

      resources = build_resource_map(domain)

      igniter
      |> maybe_install_ash_postgres()
      |> Igniter.Project.Formatter.import_dep(:ash)
      |> Igniter.Project.Formatter.add_formatter_plugin(Spark.Formatter)
      |> Igniter.Project.Deps.add_dep({:alexandria, "~> 0.1"}, on_exists: :skip)
      |> ensure_ash_domains_config(otp_app, domain)
      |> create_domain_module(domain, resources)
      |> create_resource_modules(otp_app, domain, resources)
    end

    # --- Resource definitions ---------------------------------------------

    defp build_resource_map(domain) do
      [
        category: %{
          module: Module.concat(domain, "Category"),
          extension: Alexandria.Core.Resource.Category,
          section: :alexandria_category,
          table: "alexandria_categories",
          refs: [{:document_resource, Module.concat(domain, "Document")}]
        },
        document: %{
          module: Module.concat(domain, "Document"),
          extension: Alexandria.Core.Resource.Document,
          section: :alexandria_document,
          table: "alexandria_documents",
          refs: [
            {:category_resource, Module.concat(domain, "Category")},
            {:tag_resource, Module.concat(domain, "Tag")},
            {:mark_resource, Module.concat(domain, "Mark")},
            {:file_resource, Module.concat(domain, "File")},
            {:document_tag_resource, Module.concat(domain, "DocumentTag")},
            {:document_mark_resource, Module.concat(domain, "DocumentMark")}
          ]
        },
        document_mark: %{
          module: Module.concat(domain, "DocumentMark"),
          extension: Alexandria.Core.Resource.DocumentMark,
          section: :alexandria_document_mark,
          table: "alexandria_document_marks",
          refs: [
            {:document_resource, Module.concat(domain, "Document")},
            {:mark_resource, Module.concat(domain, "Mark")}
          ]
        },
        document_tag: %{
          module: Module.concat(domain, "DocumentTag"),
          extension: Alexandria.Core.Resource.DocumentTag,
          section: :alexandria_document_tag,
          table: "alexandria_document_tags",
          refs: [
            {:document_resource, Module.concat(domain, "Document")},
            {:tag_resource, Module.concat(domain, "Tag")}
          ]
        },
        file: %{
          module: Module.concat(domain, "File"),
          extension: Alexandria.Core.Resource.File,
          section: :alexandria_file,
          table: "alexandria_files",
          refs: [{:document_resource, Module.concat(domain, "Document")}]
        },
        mark: %{
          module: Module.concat(domain, "Mark"),
          extension: Alexandria.Core.Resource.Mark,
          section: :alexandria_mark,
          table: "alexandria_marks",
          refs: []
        },
        tag: %{
          module: Module.concat(domain, "Tag"),
          extension: Alexandria.Core.Resource.Tag,
          section: :alexandria_tag,
          table: "alexandria_tags",
          refs: [{:tag_synonym_group_resource, Module.concat(domain, "TagSynonymGroup")}]
        },
        tag_synonym_group: %{
          module: Module.concat(domain, "TagSynonymGroup"),
          extension: Alexandria.Core.Resource.TagSynonymGroup,
          section: :alexandria_tag_synonym_group,
          table: "alexandria_tag_synonym_groups",
          refs: [{:tag_resource, Module.concat(domain, "Tag")}]
        }
      ]
    end

    # --- Composition helpers ----------------------------------------------

    defp maybe_install_ash_postgres(igniter) do
      if Igniter.Project.Deps.has_dep?(igniter, :ash_postgres) do
        igniter
      else
        Igniter.compose_task(igniter, "ash_postgres.install", igniter.args.argv_flags)
      end
    end

    defp ensure_ash_domains_config(igniter, otp_app, domain) do
      Igniter.Project.Config.configure(
        igniter,
        "config.exs",
        otp_app,
        [:ash_domains],
        [domain],
        updater: fn zipper ->
          Igniter.Code.List.append_new_to_list(zipper, domain)
        end
      )
    end

    # --- Code generation --------------------------------------------------

    defp create_domain_module(igniter, domain, resources) do
      resource_lines =
        resources
        |> Enum.map(fn {_key, %{module: mod}} -> "    resource #{inspect(mod)}" end)
        |> Enum.join("\n")

      contents = """
      @moduledoc \"\"\"
      Consumer-owned Ash domain assembled by `mix alexandria.install`.

      Resources here use `Alexandria.Core.Resource.*` extensions which
      inject the Alexandria-shaped attributes, relationships, actions, and
      calculations at compile time. The data layer, repo, policies, and
      any additional actions are owned by this app.
      \"\"\"
      use Ash.Domain

      resources do
      #{resource_lines}
      end
      """

      create_module_if_missing(igniter, domain, contents)
    end

    defp create_resource_modules(igniter, otp_app, domain, resources) do
      repo = pick_repo(igniter)

      Enum.reduce(resources, igniter, fn {_key, spec}, igniter ->
        create_resource_module(igniter, otp_app, domain, repo, spec)
      end)
    end

    defp create_resource_module(igniter, otp_app, domain, repo, spec) do
      contents = resource_module_contents(otp_app, domain, repo, spec)
      create_module_if_missing(igniter, spec.module, contents)
    end

    # Best-effort repo lookup. Tries the consumer's existing Ecto repo first;
    # falls back to `<AppPrefix>.Repo`. `ash_postgres.install` is composed
    # above, which guarantees a repo exists by the time these resources
    # are compiled.
    defp pick_repo(igniter) do
      case Igniter.Libs.Ecto.list_repos(igniter) do
        {_igniter, [repo | _]} -> repo
        _ -> Igniter.Project.Module.module_name(igniter, "Repo")
      end
    end

    # Idempotent module creation: if the module already exists in the
    # project we skip silently rather than emitting an error. `create_module`
    # itself doesn't forward `:on_exists`, so we route through the lower
    # level `create_new_file` to get `:skip` behaviour.
    defp create_module_if_missing(igniter, module_name, contents) do
      case Igniter.Project.Module.module_exists(igniter, module_name) do
        {true, igniter} ->
          igniter

        {false, igniter} ->
          path = Igniter.Project.Module.proper_location(igniter, module_name)

          file_contents = """
          defmodule #{inspect(module_name)} do
            #{contents}
          end
          """

          Igniter.create_new_file(igniter, path, file_contents, on_exists: :skip)
      end
    end

    defp resource_module_contents(otp_app, domain, repo, spec) do
      """
      @moduledoc false
      use Ash.Resource,
        otp_app: #{inspect(otp_app)},
        domain: #{inspect(domain)},
        data_layer: AshPostgres.DataLayer,
        extensions: [#{inspect(spec.extension)}]

      postgres do
        table #{inspect(spec.table)}
        repo #{inspect(repo)}
      end
      #{render_section(spec)}
      """
    end

    defp render_section(%{refs: []}), do: ""

    defp render_section(%{section: section, refs: refs}) do
      ref_lines =
        refs
        |> Enum.map(fn {name, mod} -> "  #{name} #{inspect(mod)}" end)
        |> Enum.join("\n")

      """

      #{section} do
      #{ref_lines}
      end
      """
    end
  end
else
  defmodule Mix.Tasks.Alexandria.Install do
    @shortdoc "#{__MODULE__.Docs.short_doc()} | Install `igniter` to use"

    @moduledoc __MODULE__.Docs.long_doc()

    use Mix.Task

    def run(_argv) do
      Mix.shell().error("""
      The task 'alexandria.install' requires igniter. Please install
      igniter and try again.

      For more information, see: https://hexdocs.pm/igniter/readme.html#installation
      """)

      exit({:shutdown, 1})
    end
  end
end
