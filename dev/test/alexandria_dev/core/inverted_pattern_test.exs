defmodule AlexandriaDev.Core.InvertedPatternTest do
  @moduledoc """
  Proves the inverted Alexandria extension pattern compiles and the
  convention-based `belongs_to :category` injection works end-to-end via
  ETS. No DB, no migrations.
  """
  use ExUnit.Case, async: false

  setup do
    on_exit(fn ->
      Ash.DataLayer.Ets.stop(AlexandriaDev.Core.Document)
      Ash.DataLayer.Ets.stop(AlexandriaDev.Core.Category)
    end)

    :ok
  end

  test "Category extension injects :slug and :name attributes" do
    attrs = Ash.Resource.Info.public_attributes(AlexandriaDev.Core.Category)
    names = Enum.map(attrs, & &1.name) |> Enum.sort()
    assert :slug in names
    assert :name in names
  end

  test "Document extension injects :id, :title, and :category_id" do
    attrs = Ash.Resource.Info.public_attributes(AlexandriaDev.Core.Document)
    names = Enum.map(attrs, & &1.name) |> Enum.sort()
    assert :id in names
    assert :title in names
    assert :category_id in names
  end

  test "Document belongs_to :category wired from alexandria_document section" do
    rel = Ash.Resource.Info.relationship(AlexandriaDev.Core.Document, :category)
    assert rel.type == :belongs_to
    assert rel.destination == AlexandriaDev.Core.Category
    assert rel.source_attribute == :category_id
    assert rel.destination_attribute == :slug
  end

  test "Category has_many :documents wired from alexandria_category section" do
    rel = Ash.Resource.Info.relationship(AlexandriaDev.Core.Category, :documents)
    assert rel.type == :has_many
    assert rel.destination == AlexandriaDev.Core.Document
    assert rel.source_attribute == :slug
    assert rel.destination_attribute == :category_id
  end

  test "default actions injected by both extensions" do
    for resource <- [AlexandriaDev.Core.Category, AlexandriaDev.Core.Document] do
      names = resource |> Ash.Resource.Info.actions() |> Enum.map(& &1.name) |> Enum.sort()
      assert Enum.member?(names, :read)
      assert Enum.member?(names, :create)
      assert Enum.member?(names, :update)
    end
  end

  test "create + load: belongs_to traversal works at runtime" do
    {:ok, cat} =
      AlexandriaDev.Core.Category
      |> Ash.Changeset.for_create(:create, %{slug: "books", name: "Books"})
      |> Ash.create()

    {:ok, doc} =
      AlexandriaDev.Core.Document
      |> Ash.Changeset.for_create(:create, %{title: "Hello", category_id: cat.slug})
      |> Ash.create()

    loaded = Ash.load!(doc, :category)
    assert loaded.category.slug == "books"
    assert loaded.category.name == "Books"
  end
end
