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

  test "Category extension injects full attribute set" do
    names =
      AlexandriaDev.Core.Category
      |> Ash.Resource.Info.attributes()
      |> Enum.map(& &1.name)
      |> MapSet.new()

    for attr <- [
          :slug,
          :name,
          :description,
          :color,
          :sort,
          :metainfo,
          :created_by_user,
          :created_by_group,
          :created_at,
          :modified_at
        ] do
      assert attr in names, "missing attribute #{inspect(attr)}"
    end

    name_attr = Ash.Resource.Info.attribute(AlexandriaDev.Core.Category, :name)
    assert name_attr.type == Alexandria.Types.Multilingual
    desc_attr = Ash.Resource.Info.attribute(AlexandriaDev.Core.Category, :description)
    assert desc_attr.type == Alexandria.Types.Multilingual
  end

  test "Category self-referential parent/children relationships wired" do
    parent = Ash.Resource.Info.relationship(AlexandriaDev.Core.Category, :parent)
    assert parent.type == :belongs_to
    assert parent.destination == AlexandriaDev.Core.Category
    assert parent.source_attribute == :parent_id
    assert parent.destination_attribute == :slug

    children = Ash.Resource.Info.relationship(AlexandriaDev.Core.Category, :children)
    assert children.type == :has_many
    assert children.destination == AlexandriaDev.Core.Category
    assert children.source_attribute == :slug
    assert children.destination_attribute == :parent_id
  end

  test "Category named actions injected" do
    names =
      AlexandriaDev.Core.Category
      |> Ash.Resource.Info.actions()
      |> Enum.map(& &1.name)
      |> MapSet.new()

    for action <- [
          :list_roots,
          :list_children,
          :create_root,
          :create_child,
          :rename,
          :recolor,
          :reorder,
          :set_metainfo
        ] do
      assert action in names, "missing action #{inspect(action)}"
    end
  end

  test "Category calculations and aggregates injected" do
    calc_names =
      AlexandriaDev.Core.Category
      |> Ash.Resource.Info.calculations()
      |> Enum.map(& &1.name)
      |> MapSet.new()

    assert :display_name in calc_names
    assert :display_description in calc_names

    agg_names =
      AlexandriaDev.Core.Category
      |> Ash.Resource.Info.aggregates()
      |> Enum.map(& &1.name)
      |> MapSet.new()

    assert :active_document_count in agg_names
  end

  test "Document extension injects :id, :title, and :category_id" do
    attrs = Ash.Resource.Info.public_attributes(AlexandriaDev.Core.Document)
    names = Enum.map(attrs, & &1.name) |> Enum.sort()
    assert :id in names
    assert :title in names
    assert :category_id in names
  end

  test "Document extension injects full Alexandria attribute set" do
    names =
      AlexandriaDev.Core.Document
      |> Ash.Resource.Info.attributes()
      |> Enum.map(& &1.name)
      |> MapSet.new()

    for attr <- [
          :id,
          :title,
          :description,
          :date,
          :metainfo,
          :created_by_user,
          :created_by_group,
          :created_at,
          :modified_at,
          :category_id
        ] do
      assert attr in names, "missing Document attribute #{inspect(attr)}"
    end

    title = Ash.Resource.Info.attribute(AlexandriaDev.Core.Document, :title)
    assert title.type == Alexandria.Types.Multilingual
    assert title.allow_nil? == false

    desc = Ash.Resource.Info.attribute(AlexandriaDev.Core.Document, :description)
    assert desc.type == Alexandria.Types.Multilingual

    date = Ash.Resource.Info.attribute(AlexandriaDev.Core.Document, :date)
    assert date.type == Ash.Type.Date

    meta = Ash.Resource.Info.attribute(AlexandriaDev.Core.Document, :metainfo)
    assert meta.type == Ash.Type.Map
    assert meta.default == %{}
  end

  test "Document belongs_to :category wired from alexandria_document section" do
    rel = Ash.Resource.Info.relationship(AlexandriaDev.Core.Document, :category)
    assert rel.type == :belongs_to
    assert rel.destination == AlexandriaDev.Core.Category
    assert rel.source_attribute == :category_id
    assert rel.destination_attribute == :slug
  end

  test "Document many_to_many :tags wired via DocumentTag join" do
    rel = Ash.Resource.Info.relationship(AlexandriaDev.Core.Document, :tags)
    assert rel.type == :many_to_many
    assert rel.destination == AlexandriaDev.Core.Tag
    assert rel.through == AlexandriaDev.Core.DocumentTag
    assert rel.source_attribute_on_join_resource == :document_id
    assert rel.destination_attribute_on_join_resource == :tag_id
    assert rel.destination_attribute == :slug
  end

  test "Document many_to_many :marks wired via DocumentMark join" do
    rel = Ash.Resource.Info.relationship(AlexandriaDev.Core.Document, :marks)
    assert rel.type == :many_to_many
    assert rel.destination == AlexandriaDev.Core.Mark
    assert rel.through == AlexandriaDev.Core.DocumentMark
    assert rel.source_attribute_on_join_resource == :document_id
    assert rel.destination_attribute_on_join_resource == :mark_id
    assert rel.destination_attribute == :slug
  end

  test "Document has_many :files wired to File resource" do
    rel = Ash.Resource.Info.relationship(AlexandriaDev.Core.Document, :files)
    assert rel.type == :has_many
    assert rel.destination == AlexandriaDev.Core.File
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

  test "Document extension injects all Alexandria named actions" do
    names =
      AlexandriaDev.Core.Document
      |> Ash.Resource.Info.actions()
      |> Enum.map(& &1.name)
      |> MapSet.new()

    for action <- [
          :read,
          :list_by_category,
          :list_active_by_category,
          :by_tag,
          :by_mark,
          :list_active_by_tag,
          :list_active_by_mark,
          :list_by_ids,
          :create,
          :upload,
          :rename,
          :edit_description,
          :set_date,
          :move_to_category,
          :set_metainfo,
          :add_tag,
          :remove_tag,
          :add_mark,
          :remove_mark,
          :archive,
          :restore,
          :update_title_description_date
        ] do
      assert action in names, "missing Document action #{inspect(action)}"
    end
  end

  test "Document :list_by_category accepts :category_id argument" do
    action = Ash.Resource.Info.action(AlexandriaDev.Core.Document, :list_by_category)
    assert action.type == :read
    arg_names = Enum.map(action.arguments, & &1.name)
    assert :category_id in arg_names
  end

  test "Document :upload requires file metadata arguments" do
    action = Ash.Resource.Info.action(AlexandriaDev.Core.Document, :upload)
    assert action.type == :create
    arg_names = action.arguments |> Enum.map(& &1.name) |> MapSet.new()
    for n <- [:category_id, :file_name, :mime_type, :size, :bytes], do: assert(n in arg_names)
  end

  test "Document :archive uses ToggleArchived change with :on flag" do
    action = Ash.Resource.Info.action(AlexandriaDev.Core.Document, :archive)
    assert action.require_atomic? == false

    assert Enum.any?(action.changes, fn c ->
             match?({Alexandria.Core.Document.Changes.ToggleArchived, [flag: :on]}, c.change)
           end)
  end

  test "Document :restore uses ToggleArchived change with :off flag" do
    action = Ash.Resource.Info.action(AlexandriaDev.Core.Document, :restore)

    assert Enum.any?(action.changes, fn c ->
             match?({Alexandria.Core.Document.Changes.ToggleArchived, [flag: :off]}, c.change)
           end)
  end

  test "Document calculations: display_title, display_description, archived?" do
    calcs =
      AlexandriaDev.Core.Document
      |> Ash.Resource.Info.calculations()
      |> Enum.map(& &1.name)
      |> MapSet.new()

    for n <- [:display_title, :display_description, :archived?], do: assert(n in calcs)

    title_calc = Ash.Resource.Info.calculation(AlexandriaDev.Core.Document, :display_title)
    assert title_calc.calculation == {Alexandria.Calculations.LocalizedField, attribute: :title}

    desc_calc = Ash.Resource.Info.calculation(AlexandriaDev.Core.Document, :display_description)

    assert desc_calc.calculation ==
             {Alexandria.Calculations.LocalizedField, attribute: :description}
  end

  test "Document aggregate :tags_slugs lists :tags relationship :slug field" do
    agg = Ash.Resource.Info.aggregate(AlexandriaDev.Core.Document, :tags_slugs)
    assert agg
    assert agg.kind == :list
    assert agg.relationship_path == [:tags]
    assert agg.field == :slug
  end

  test "Document preparations load display_title + display_description" do
    preps = Ash.Resource.Info.preparations(AlexandriaDev.Core.Document)

    assert Enum.any?(preps, fn p ->
             match?(
               {Ash.Resource.Preparation.Build,
                [options: [load: [:display_title, :display_description]]]},
               p.preparation
             )
           end)
  end

  @tag :db
  test "create + load: belongs_to traversal works at runtime" do
    {:ok, cat} =
      AlexandriaDev.Core.Category
      |> Ash.Changeset.for_create(:create, %{
        slug: "books",
        name: %{"en" => "Books"},
        color: "#aabbcc"
      })
      |> Ash.create()

    {:ok, doc} =
      AlexandriaDev.Core.Document
      |> Ash.Changeset.for_create(:create, %{
        title: %{"en" => "Hello"},
        category_id: cat.slug
      })
      |> Ash.create()

    loaded = Ash.load!(doc, :category)
    assert loaded.category.slug == "books"
    assert loaded.category.name == %{"en" => "Books"}
  end
end
