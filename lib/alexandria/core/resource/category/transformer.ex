defmodule Alexandria.Core.Resource.Category.Transformer do
  @moduledoc false
  use Spark.Dsl.Transformer
  import Spark.Dsl.Builder
  import Ash.Expr

  alias Alexandria.Core.Resource.Category.Info
  alias Ash.Resource.Builder

  def before?(Ash.Resource.Transformers.SetRelationshipSource), do: true
  def before?(Ash.Resource.Transformers.BelongsToAttribute), do: true
  def before?(Ash.Resource.Transformers.CachePrimaryKey), do: true
  def before?(_), do: false

  def transform(dsl) do
    self_module = Spark.Dsl.Transformer.get_persisted(dsl, :module)
    document_resource = Info.alexandria_category_document_resource!(dsl)

    dsl
    |> add_attributes()
    |> add_relationships(self_module, document_resource)
    |> add_actions()
    |> add_preparations()
    |> add_calculations()
    |> add_aggregates()
  end

  # --- attributes ---------------------------------------------------------

  defbuilder add_attributes(dsl) do
    dsl
    |> Builder.add_new_attribute(:slug, :string,
      primary_key?: true,
      allow_nil?: false,
      public?: true
    )
    |> Builder.add_new_attribute(:name, Alexandria.Types.Multilingual,
      allow_nil?: false,
      public?: true
    )
    |> Builder.add_new_attribute(:description, Alexandria.Types.Multilingual, public?: true)
    |> Builder.add_new_attribute(:color, :string, allow_nil?: false, public?: true)
    |> Builder.add_new_attribute(:sort, :integer, default: 0, public?: true)
    |> Builder.add_new_attribute(:metainfo, :map,
      default: %{},
      allow_nil?: false,
      public?: true
    )
    |> Builder.add_new_attribute(:created_by_user, :string, public?: true)
    |> Builder.add_new_attribute(:created_by_group, :string, public?: true)
    |> Builder.add_new_create_timestamp(:created_at)
    |> Builder.add_new_update_timestamp(:modified_at)
  end

  # --- relationships ------------------------------------------------------

  defbuilder add_relationships(dsl, self_module, document_resource) do
    dsl
    |> Builder.add_new_relationship(
      :belongs_to,
      :parent,
      self_module,
      attribute_type: :string,
      source_attribute: :parent_id,
      destination_attribute: :slug,
      public?: true
    )
    |> Builder.add_new_relationship(
      :has_many,
      :children,
      self_module,
      source_attribute: :slug,
      destination_attribute: :parent_id,
      public?: true
    )
    |> Builder.add_new_relationship(
      :has_many,
      :documents,
      document_resource,
      source_attribute: :slug,
      destination_attribute: :category_id,
      public?: true
    )
  end

  # --- actions ------------------------------------------------------------

  defbuilder add_actions(dsl) do
    dsl
    |> add_primary_read_action()
    |> Builder.add_new_action(:read, :list_roots,
      filters: [%Ash.Resource.Dsl.Filter{filter: expr(is_nil(parent_id))}],
      preparations: [
        Builder.build_preparation(Ash.Resource.Preparation.Builtins.build(sort: [sort: :asc]))
      ]
    )
    |> Builder.add_new_action(:read, :list_children,
      arguments: [
        Builder.build_action_argument(:parent_id, :string, allow_nil?: false)
      ],
      filters: [
        %Ash.Resource.Dsl.Filter{filter: expr(parent_id == ^arg(:parent_id))}
      ],
      preparations: [
        Builder.build_preparation(Ash.Resource.Preparation.Builtins.build(sort: [sort: :asc]))
      ]
    )
    |> Builder.add_new_action(:create, :create_root,
      accept: [:slug, :name, :description, :color, :sort, :metainfo]
    )
    |> Builder.add_new_action(:create, :create_child,
      accept: [:slug, :name, :description, :color, :sort, :metainfo],
      arguments: [
        Builder.build_action_argument(:parent_id, :string, allow_nil?: false)
      ],
      changes: [
        Builder.build_action_change(
          Ash.Resource.Change.Builtins.manage_relationship(:parent_id, :parent, type: :append)
        )
      ]
    )
    |> Builder.add_new_action(:update, :rename, accept: [:name, :description])
    |> Builder.add_new_action(:update, :recolor, accept: [:color])
    |> Builder.add_new_action(:update, :reorder, accept: [:sort])
    |> Builder.add_new_action(:update, :set_metainfo, accept: [:metainfo])
    |> Builder.add_new_action(:create, :create, accept: :*, primary?: true)
    |> Builder.add_new_action(:update, :update, accept: :*, primary?: true)
  end

  defbuilder add_primary_read_action(dsl) do
    if Ash.Resource.Info.primary_action(dsl, :read) do
      {:ok, dsl}
    else
      Builder.add_action(dsl, :read, :read, primary?: true)
    end
  end

  # --- preparations -------------------------------------------------------

  defbuilder add_preparations(dsl) do
    Builder.add_preparation(
      dsl,
      Ash.Resource.Preparation.Builtins.build(load: [:display_name, :display_description])
    )
  end

  # --- calculations -------------------------------------------------------

  defbuilder add_calculations(dsl) do
    dsl
    |> Builder.add_new_calculation(
      :display_name,
      :string,
      {Alexandria.Calculations.LocalizedField, attribute: :name},
      public?: true
    )
    |> Builder.add_new_calculation(
      :display_description,
      :string,
      {Alexandria.Calculations.LocalizedField, attribute: :description}
    )
  end

  # --- aggregates ---------------------------------------------------------

  defbuilder add_aggregates(dsl) do
    Builder.add_new_aggregate(dsl, :active_document_count, :count, :documents,
      filter: Ash.Expr.expr(not archived?)
    )
  end
end
