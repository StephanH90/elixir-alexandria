defmodule Alexandria.Core.Resource.Tag.Transformer do
  @moduledoc false
  use Spark.Dsl.Transformer
  import Spark.Dsl.Builder

  alias Alexandria.Core.Resource.Tag.Info
  alias Ash.Resource.Builder
  alias Ash.Resource.Change.Builtins

  def before?(Ash.Resource.Transformers.SetRelationshipSource), do: true
  def before?(Ash.Resource.Transformers.BelongsToAttribute), do: true
  def before?(Ash.Resource.Transformers.CachePrimaryKey), do: true
  def before?(_), do: false

  def transform(dsl) do
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
    |> Builder.add_new_attribute(:metainfo, :map, default: %{}, public?: true)
    |> Builder.add_new_attribute(:created_by_user, :string, public?: true)
    |> Builder.add_new_attribute(:created_by_group, :string, public?: true)
    |> Builder.add_new_create_timestamp(:created_at)
    |> Builder.add_new_update_timestamp(:modified_at)
    |> Builder.add_new_relationship(
      :belongs_to,
      :tag_synonym_group,
      Info.alexandria_tag_tag_synonym_group_resource!(dsl),
      public?: true
    )
    |> add_primary_read_action()
    |> Builder.add_new_action(:create, :create,
      accept: [:slug, :name, :description, :metainfo]
    )
    |> Builder.add_new_action(:update, :rename, accept: [:name, :description])
    |> Builder.add_new_action(:update, :join_synonym_group,
      accept: [],
      require_atomic?: false,
      arguments: [Builder.build_action_argument(:group_id, :uuid, allow_nil?: false)],
      changes: [
        Builder.build_action_change(
          Builtins.manage_relationship(:group_id, :tag_synonym_group,
            type: :append_and_remove
          )
        )
      ]
    )
    |> Builder.add_new_action(:update, :leave_synonym_group,
      accept: [],
      changes: [
        Builder.build_action_change(Builtins.set_attribute(:tag_synonym_group_id, nil))
      ]
    )
    |> Builder.add_new_calculation(
      :display_name,
      :string,
      {Alexandria.Calculations.LocalizedField, attribute: :name}
    )
    |> Builder.add_new_calculation(
      :display_description,
      :string,
      {Alexandria.Calculations.LocalizedField, attribute: :description}
    )
  end

  defbuilder add_primary_read_action(dsl) do
    if Ash.Resource.Info.primary_action(dsl, :read) do
      {:ok, dsl}
    else
      Builder.add_action(dsl, :read, :read, primary?: true)
    end
  end
end
