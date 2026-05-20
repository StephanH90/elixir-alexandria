defmodule Alexandria.Core.Resource.Document.Transformer do
  @moduledoc false
  use Spark.Dsl.Transformer
  import Spark.Dsl.Builder
  import Ash.Expr
  import Ash.Resource.Change.Builtins, only: [manage_relationship: 3]

  alias Alexandria.Core.Resource.Document.Info
  alias Ash.Resource.Builder

  def before?(Ash.Resource.Transformers.SetRelationshipSource), do: true
  def before?(Ash.Resource.Transformers.BelongsToAttribute), do: true
  def before?(Ash.Resource.Transformers.CachePrimaryKey), do: true
  def before?(_), do: false

  def transform(dsl) do
    dsl
    |> inject_attributes()
    |> inject_relationships()
    |> inject_actions()
    |> inject_preparations()
    |> inject_calculations()
    |> inject_aggregates()
  end

  defbuilder inject_attributes(dsl) do
    dsl
    |> Builder.add_new_attribute(:id, :uuid,
      primary_key?: true,
      allow_nil?: false,
      public?: true,
      default: &Ash.UUID.generate/0
    )
    |> Builder.add_new_attribute(:title, Alexandria.Types.Multilingual,
      allow_nil?: false,
      public?: true
    )
    |> Builder.add_new_attribute(:description, Alexandria.Types.Multilingual, public?: true)
    |> Builder.add_new_attribute(:date, :date, public?: true)
    |> Builder.add_new_attribute(:metainfo, :map, default: %{}, public?: true)
    |> Builder.add_new_attribute(:created_by_user, :string, public?: true)
    |> Builder.add_new_attribute(:created_by_group, :string, public?: true)
    |> Builder.add_new_create_timestamp(:created_at, public?: true)
    |> Builder.add_new_update_timestamp(:modified_at, public?: true)
  end

  defbuilder inject_relationships(dsl) do
    dsl
    |> Builder.add_new_relationship(
      :belongs_to,
      :category,
      Info.alexandria_document_category_resource!(dsl),
      source_attribute: :category_id,
      destination_attribute: :slug,
      attribute_type: :string,
      allow_nil?: false,
      public?: true
    )
    |> Builder.add_new_relationship(
      :many_to_many,
      :tags,
      Info.alexandria_document_tag_resource!(dsl),
      through: Info.alexandria_document_document_tag_resource!(dsl),
      source_attribute_on_join_resource: :document_id,
      destination_attribute_on_join_resource: :tag_id,
      destination_attribute: :slug,
      public?: true
    )
    |> Builder.add_new_relationship(
      :many_to_many,
      :marks,
      Info.alexandria_document_mark_resource!(dsl),
      through: Info.alexandria_document_document_mark_resource!(dsl),
      source_attribute_on_join_resource: :document_id,
      destination_attribute_on_join_resource: :mark_id,
      destination_attribute: :slug,
      public?: true
    )
    |> Builder.add_new_relationship(
      :has_many,
      :files,
      Info.alexandria_document_file_resource!(dsl),
      destination_attribute: :document_id,
      public?: true
    )
  end

  defbuilder inject_actions(dsl) do
    dsl
    |> add_primary_read_action()
    |> Builder.add_new_action(:read, :list_by_category,
      arguments: [build_arg(:category_id, :string, allow_nil?: false)],
      filters: [build_filter(expr(category_id == ^arg(:category_id)))]
    )
    |> Builder.add_new_action(:read, :list_active_by_category,
      arguments: [build_arg(:category_id, :string, allow_nil?: false)],
      filters: [build_filter(expr(category_id == ^arg(:category_id) and not archived?))],
      preparations: [build_prep_sort_modified_desc()]
    )
    |> Builder.add_new_action(:read, :by_tag,
      arguments: [build_arg(:tag_id, :string, allow_nil?: false)],
      filters: [build_filter(expr(exists(tags, slug == ^arg(:tag_id))))]
    )
    |> Builder.add_new_action(:read, :by_mark,
      arguments: [build_arg(:mark_id, :string, allow_nil?: false)],
      filters: [build_filter(expr(exists(marks, slug == ^arg(:mark_id))))]
    )
    |> Builder.add_new_action(:read, :list_active_by_tag,
      arguments: [build_arg(:tag_id, :string, allow_nil?: false)],
      filters: [build_filter(expr(exists(tags, slug == ^arg(:tag_id)) and not archived?))],
      preparations: [build_prep_sort_modified_desc()]
    )
    |> Builder.add_new_action(:read, :list_active_by_mark,
      arguments: [build_arg(:mark_id, :string, allow_nil?: false)],
      filters: [build_filter(expr(exists(marks, slug == ^arg(:mark_id)) and not archived?))],
      preparations: [build_prep_sort_modified_desc()]
    )
    |> Builder.add_new_action(:read, :list_by_ids,
      arguments: [build_arg(:ids, {:array, :uuid}, allow_nil?: false)],
      filters: [build_filter(expr(id in ^arg(:ids)))]
    )
    |> Builder.add_new_action(:create, :create,
      primary?: true,
      accept: [:title, :description, :date, :metainfo],
      arguments: [build_arg(:category_id, :string, allow_nil?: false)],
      changes: [
        build_action_change_ok(manage_relationship(:category_id, :category, type: :append))
      ]
    )
    |> Builder.add_new_action(:create, :upload,
      accept: [:title, :description, :date, :metainfo],
      arguments: [
        build_arg(:category_id, :string, allow_nil?: false),
        build_arg(:file_name, :string, allow_nil?: false),
        build_arg(:mime_type, :string, allow_nil?: false),
        build_arg(:size, :integer, allow_nil?: false),
        build_arg(:bytes, :string, allow_nil?: false)
      ],
      changes: [
        build_action_change_ok(manage_relationship(:category_id, :category, type: :append)),
        build_action_change_ok(Alexandria.Core.Document.Changes.CreateInitialFile)
      ]
    )
    # A no-op generic :update action so that consumers (and the existing
    # default-action test) see a default `:update` even though the
    # legacy resource only defined named update actions.
    |> Builder.add_new_action(:update, :update, accept: :*, primary?: true)
    |> Builder.add_new_action(:update, :rename, accept: [:title])
    |> Builder.add_new_action(:update, :edit_description, accept: [:description])
    |> Builder.add_new_action(:update, :set_date, accept: [:date])
    |> Builder.add_new_action(:update, :move_to_category,
      require_atomic?: false,
      arguments: [build_arg(:category_id, :string, allow_nil?: false)],
      changes: [
        build_action_change_ok(
          manage_relationship(:category_id, :category, type: :append_and_remove)
        )
      ]
    )
    |> Builder.add_new_action(:update, :set_metainfo, accept: [:metainfo])
    |> Builder.add_new_action(:update, :add_tag,
      require_atomic?: false,
      arguments: [build_arg(:tag_id, :string, allow_nil?: false)],
      changes: [
        build_action_change_ok(
          manage_relationship(:tag_id, :tags, type: :append, on_no_match: :error)
        )
      ]
    )
    |> Builder.add_new_action(:update, :remove_tag,
      require_atomic?: false,
      arguments: [build_arg(:tag_id, :string, allow_nil?: false)],
      changes: [
        build_action_change_ok(manage_relationship(:tag_id, :tags, type: :remove))
      ]
    )
    |> Builder.add_new_action(:update, :add_mark,
      require_atomic?: false,
      arguments: [build_arg(:mark_id, :string, allow_nil?: false)],
      changes: [
        build_action_change_ok(
          manage_relationship(:mark_id, :marks, type: :append, on_no_match: :error)
        )
      ]
    )
    |> Builder.add_new_action(:update, :remove_mark,
      require_atomic?: false,
      arguments: [build_arg(:mark_id, :string, allow_nil?: false)],
      changes: [
        build_action_change_ok(manage_relationship(:mark_id, :marks, type: :remove))
      ]
    )
    |> Builder.add_new_action(:update, :archive,
      require_atomic?: false,
      changes: [
        build_action_change_ok({Alexandria.Core.Document.Changes.ToggleArchived, flag: :on})
      ]
    )
    |> Builder.add_new_action(:update, :restore,
      require_atomic?: false,
      changes: [
        build_action_change_ok({Alexandria.Core.Document.Changes.ToggleArchived, flag: :off})
      ]
    )
    |> Builder.add_new_action(:update, :update_title_description_date,
      accept: [:title, :description, :date]
    )
  end

  defbuilder add_primary_read_action(dsl) do
    if Ash.Resource.Info.primary_action(dsl, :read) do
      {:ok, dsl}
    else
      Builder.add_action(dsl, :read, :read, primary?: true)
    end
  end

  defbuilder inject_preparations(dsl) do
    Builder.add_preparation(
      dsl,
      {Ash.Resource.Preparation.Build, options: [load: [:display_title, :display_description]]}
    )
  end

  defbuilder inject_calculations(dsl) do
    dsl
    |> Builder.add_new_calculation(
      :display_title,
      :string,
      {Alexandria.Calculations.LocalizedField, attribute: :title}
    )
    |> Builder.add_new_calculation(
      :display_description,
      :string,
      {Alexandria.Calculations.LocalizedField, attribute: :description}
    )
    |> Builder.add_new_calculation(
      :archived?,
      :boolean,
      expr(not is_nil(fragment("?->>'archived_at'", metainfo)))
    )
  end

  defbuilder inject_aggregates(dsl) do
    Builder.add_new_aggregate(dsl, :tags_slugs, :list, :tags, field: :slug, public?: true)
  end

  # --- helpers ------------------------------------------------------------

  defp build_arg(name, type, opts) do
    {:ok, arg} = Builder.build_action_argument(name, type, opts)
    arg
  end

  defp build_filter(expr), do: %Ash.Resource.Dsl.Filter{filter: expr}

  defp build_prep_sort_modified_desc do
    {:ok, prep} =
      Builder.build_preparation(
        {Ash.Resource.Preparation.Build, options: [sort: [modified_at: :desc]]},
        []
      )

    prep
  end

  defp build_action_change_ok(ref) do
    {:ok, change} = Builder.build_action_change(ref, [])
    change
  end
end
