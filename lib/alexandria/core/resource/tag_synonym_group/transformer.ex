defmodule Alexandria.Core.Resource.TagSynonymGroup.Transformer do
  @moduledoc false
  use Spark.Dsl.Transformer
  import Spark.Dsl.Builder

  alias Alexandria.Core.Resource.TagSynonymGroup.Info

  def before?(Ash.Resource.Transformers.SetRelationshipSource), do: true
  def before?(Ash.Resource.Transformers.BelongsToAttribute), do: true
  def before?(Ash.Resource.Transformers.CachePrimaryKey), do: true
  def before?(_), do: false

  def transform(dsl) do
    dsl
    |> Ash.Resource.Builder.add_new_attribute(:id, :uuid,
      primary_key?: true,
      allow_nil?: false,
      public?: true,
      default: &Ash.UUID.generate/0
    )
    |> Ash.Resource.Builder.add_new_attribute(:name, Alexandria.Types.Multilingual,
      allow_nil?: false,
      public?: true
    )
    |> Ash.Resource.Builder.add_new_relationship(
      :has_many,
      :tags,
      Info.alexandria_tag_synonym_group_tag_resource!(dsl),
      destination_attribute: :tag_synonym_group_id,
      public?: true
    )
    |> add_primary_read_action()
    |> Ash.Resource.Builder.add_new_action(:create, :create,
      primary?: true,
      accept: [:name]
    )
    |> Ash.Resource.Builder.add_new_action(:update, :rename, accept: [:name])
    |> Ash.Resource.Builder.add_new_calculation(
      :display_name,
      :string,
      {Alexandria.Calculations.LocalizedField, attribute: :name}
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
