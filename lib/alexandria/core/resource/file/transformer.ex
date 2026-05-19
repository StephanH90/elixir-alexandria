defmodule Alexandria.Core.Resource.File.Transformer do
  @moduledoc false
  use Spark.Dsl.Transformer
  import Spark.Dsl.Builder
  import Ash.Expr

  alias Alexandria.Core.Resource.File.Info
  alias Spark.Dsl.Transformer

  def before?(Ash.Resource.Transformers.SetRelationshipSource), do: true
  def before?(Ash.Resource.Transformers.BelongsToAttribute), do: true
  def before?(Ash.Resource.Transformers.CachePrimaryKey), do: true
  def before?(_), do: false

  def transform(dsl) do
    self_module = Transformer.get_persisted(dsl, :module)
    document_resource = Info.alexandria_file_document_resource!(dsl)

    dsl
    |> Ash.Resource.Builder.add_new_attribute(:id, :uuid,
      primary_key?: true,
      allow_nil?: false,
      public?: true,
      default: &Ash.UUID.generate/0
    )
    |> Ash.Resource.Builder.add_new_attribute(:name, :string,
      allow_nil?: false,
      public?: true
    )
    |> Ash.Resource.Builder.add_new_attribute(:variant, :atom,
      constraints: [one_of: [:original, :thumbnail, :rendering]],
      default: :original,
      allow_nil?: false,
      public?: true
    )
    |> Ash.Resource.Builder.add_new_attribute(:content, :string,
      allow_nil?: false,
      public?: true
    )
    |> Ash.Resource.Builder.add_new_attribute(:mime_type, :string,
      allow_nil?: false,
      public?: true
    )
    |> Ash.Resource.Builder.add_new_attribute(:size, :integer,
      allow_nil?: false,
      public?: true
    )
    |> Ash.Resource.Builder.add_new_attribute(:checksum, :string,
      allow_nil?: false,
      public?: true
    )
    |> Ash.Resource.Builder.add_new_attribute(:metainfo, :map,
      default: %{},
      public?: true
    )
    |> Ash.Resource.Builder.add_new_attribute(:created_by_user, :string, public?: true)
    |> Ash.Resource.Builder.add_new_attribute(:created_by_group, :string, public?: true)
    |> Ash.Resource.Builder.add_new_create_timestamp(:created_at)
    |> Ash.Resource.Builder.add_new_update_timestamp(:modified_at)
    |> Ash.Resource.Builder.add_new_relationship(
      :belongs_to,
      :document,
      document_resource,
      allow_nil?: false,
      public?: true
    )
    |> Ash.Resource.Builder.add_new_relationship(
      :belongs_to,
      :original,
      self_module,
      public?: true
    )
    |> add_primary_read_action()
    |> add_for_document_action()
    |> add_upload_action(:upload_original, :original, with_original?: false)
    |> add_upload_action(:upload_thumbnail, :thumbnail, with_original?: true)
    |> add_upload_action(:upload_rendering, :rendering, with_original?: true)
    |> add_rename_action()
    |> add_replace_content_action()
    |> add_download_url_action(self_module)
    |> Ash.Resource.Builder.add_new_calculation(
      :display_size,
      :string,
      Alexandria.Calculations.HumanSize
    )
  end

  defbuilder add_primary_read_action(dsl) do
    if Ash.Resource.Info.primary_action(dsl, :read) do
      {:ok, dsl}
    else
      Ash.Resource.Builder.add_action(dsl, :read, :read, primary?: true)
    end
  end

  defbuilder add_for_document_action(dsl) do
    if Ash.Resource.Info.action(dsl, :for_document) do
      {:ok, dsl}
    else
      with {:ok, document_id_arg} <-
             Ash.Resource.Builder.build_action_argument(:document_id, :uuid, allow_nil?: false),
           {:ok, filter} <-
             Transformer.build_entity(
               Ash.Resource.Dsl,
               [:actions, :read],
               :filter,
               filter: expr(document_id == ^arg(:document_id))
             ),
           {:ok, action} <-
             Ash.Resource.Builder.build_action(:read, :for_document,
               arguments: [document_id_arg],
               filters: [filter]
             ) do
        Transformer.add_entity(dsl, [:actions], action, type: :append)
      end
    end
  end

  defbuilder add_upload_action(dsl, name, variant, opts) do
    if Ash.Resource.Info.action(dsl, name) do
      {:ok, dsl}
    else
      with_original? = Keyword.fetch!(opts, :with_original?)

      args =
        [
          Ash.Resource.Builder.build_action_argument(:document_id, :uuid, allow_nil?: false),
          Ash.Resource.Builder.build_action_argument(:bytes, :string, allow_nil?: false)
        ] ++
          if with_original? do
            [Ash.Resource.Builder.build_action_argument(:original_id, :uuid, allow_nil?: false)]
          else
            []
          end

      base_changes = [
        Ash.Resource.Builder.build_action_change(
          Ash.Resource.Change.Builtins.manage_relationship(:document_id, :document, type: :append)
        )
      ]

      original_change =
        if with_original? do
          [
            Ash.Resource.Builder.build_action_change(
              Ash.Resource.Change.Builtins.manage_relationship(:original_id, :original,
                type: :append
              )
            )
          ]
        else
          []
        end

      tail_changes = [
        Ash.Resource.Builder.build_action_change(
          Ash.Resource.Change.Builtins.set_attribute(:variant, variant)
        ),
        Ash.Resource.Builder.build_action_change(Alexandria.Core.File.Changes.PutBytes)
      ]

      Ash.Resource.Builder.add_action(dsl, :create, name,
        accept: [:name, :mime_type, :size],
        arguments: args,
        changes: base_changes ++ original_change ++ tail_changes
      )
    end
  end

  defbuilder add_rename_action(dsl) do
    Ash.Resource.Builder.add_new_action(dsl, :update, :rename, accept: [:name])
  end

  defbuilder add_replace_content_action(dsl) do
    if Ash.Resource.Info.action(dsl, :replace_content) do
      {:ok, dsl}
    else
      Ash.Resource.Builder.add_action(dsl, :update, :replace_content,
        accept: [:mime_type, :size],
        require_atomic?: false,
        arguments: [
          Ash.Resource.Builder.build_action_argument(:bytes, :string, allow_nil?: false)
        ],
        changes: [
          Ash.Resource.Builder.build_action_change(Alexandria.Core.File.Changes.ReplaceBytes)
        ]
      )
    end
  end

  defbuilder add_download_url_action(dsl, self_module) do
    if Ash.Resource.Info.action(dsl, :download_url) do
      {:ok, dsl}
    else
      Ash.Resource.Builder.add_action(dsl, :action, :download_url,
        returns: :string,
        arguments: [
          Ash.Resource.Builder.build_action_argument(:id, :uuid, allow_nil?: false)
        ],
        run:
          {Ash.Resource.Action.ImplementationFunction,
           fun: {__MODULE__, :run_download_url, [self_module]}}
      )
    end
  end

  @doc false
  def run_download_url(input, _ctx, resource) do
    case Ash.get(resource, input.arguments.id) do
      {:ok, %{content: key}} -> Alexandria.Storage.presigned_url(key)
      {:error, _} = e -> e
    end
  end
end
