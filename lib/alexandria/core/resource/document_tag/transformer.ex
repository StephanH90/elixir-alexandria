defmodule Alexandria.Core.Resource.DocumentTag.Transformer do
  @moduledoc false
  use Spark.Dsl.Transformer
  import Spark.Dsl.Builder

  alias Alexandria.Core.Resource.DocumentTag.Info

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
    |> Ash.Resource.Builder.add_new_relationship(
      :belongs_to,
      :document,
      Info.alexandria_document_tag_document_resource!(dsl),
      allow_nil?: false,
      public?: true
    )
    |> Ash.Resource.Builder.add_new_relationship(
      :belongs_to,
      :tag,
      Info.alexandria_document_tag_tag_resource!(dsl),
      attribute_type: :string,
      destination_attribute: :slug,
      allow_nil?: false,
      public?: true
    )
    |> add_primary_read_action()
    |> Ash.Resource.Builder.add_new_action(:create, :create, accept: :*, primary?: true)
    |> Ash.Resource.Builder.add_new_action(:destroy, :destroy, primary?: true)
  end

  defbuilder add_primary_read_action(dsl) do
    if Ash.Resource.Info.primary_action(dsl, :read) do
      {:ok, dsl}
    else
      Ash.Resource.Builder.add_action(dsl, :read, :read, primary?: true)
    end
  end
end
