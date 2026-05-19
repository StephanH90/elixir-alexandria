defmodule Alexandria.Core.Resource.Mark.Transformer do
  @moduledoc false
  use Spark.Dsl.Transformer
  import Spark.Dsl.Builder

  def before?(Ash.Resource.Transformers.SetRelationshipSource), do: true
  def before?(Ash.Resource.Transformers.BelongsToAttribute), do: true
  def before?(Ash.Resource.Transformers.CachePrimaryKey), do: true
  def before?(_), do: false

  def transform(dsl) do
    dsl
    |> Ash.Resource.Builder.add_new_attribute(:slug, :string,
      primary_key?: true,
      allow_nil?: false,
      public?: true
    )
    |> Ash.Resource.Builder.add_new_attribute(:name, Alexandria.Types.Multilingual,
      allow_nil?: false,
      public?: true
    )
    |> Ash.Resource.Builder.add_new_attribute(:description, Alexandria.Types.Multilingual,
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
    |> add_primary_read_action()
    |> Ash.Resource.Builder.add_new_action(:create, :create,
      primary?: true,
      accept: [:slug, :name, :description, :metainfo]
    )
    |> Ash.Resource.Builder.add_new_action(:update, :rename, accept: [:name, :description])
    |> Ash.Resource.Builder.add_new_calculation(
      :display_name,
      :string,
      {Alexandria.Calculations.LocalizedField, attribute: :name}
    )
    |> Ash.Resource.Builder.add_new_calculation(
      :display_description,
      :string,
      {Alexandria.Calculations.LocalizedField, attribute: :description}
    )
  end

  defbuilder add_primary_read_action(dsl) do
    if Ash.Resource.Info.primary_action(dsl, :read) do
      {:ok, dsl}
    else
      Ash.Resource.Builder.add_action(dsl, :read, :read, primary?: true)
    end
  end
end
