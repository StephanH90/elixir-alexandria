defmodule Alexandria.Core.Resource.Category.Transformer do
  @moduledoc false
  use Spark.Dsl.Transformer
  import Spark.Dsl.Builder

  alias Alexandria.Core.Resource.Category.Info

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
    |> Ash.Resource.Builder.add_new_attribute(:name, :string,
      allow_nil?: false,
      public?: true
    )
    |> Ash.Resource.Builder.add_new_relationship(
      :has_many,
      :documents,
      Info.alexandria_category_document_resource!(dsl),
      source_attribute: :slug,
      destination_attribute: :category_id,
      public?: true
    )
    |> add_primary_read_action()
    |> Ash.Resource.Builder.add_new_action(:create, :create, accept: :*, primary?: true)
    |> Ash.Resource.Builder.add_new_action(:update, :update, accept: :*, primary?: true)
  end

  defbuilder add_primary_read_action(dsl) do
    if Ash.Resource.Info.primary_action(dsl, :read) do
      {:ok, dsl}
    else
      Ash.Resource.Builder.add_action(dsl, :read, :read, primary?: true)
    end
  end
end
