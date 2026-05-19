defmodule AlexandriaDev.Core.TagTest do
  @moduledoc """
  Proves `Alexandria.Core.Resource.Tag` extension shapes the consumer
  resource via injected attributes, relationships, actions, and
  calculations. Structural assertions only — no DB, no runtime traversal.
  """
  use ExUnit.Case, async: true

  alias AlexandriaDev.Core.Tag

  test "extension injects expected public attributes" do
    names =
      Tag
      |> Ash.Resource.Info.public_attributes()
      |> Enum.map(& &1.name)

    for attr <- [
          :slug,
          :name,
          :description,
          :metainfo,
          :created_by_user,
          :created_by_group,
          :tag_synonym_group_id
        ] do
      assert attr in names, "expected #{inspect(attr)} in #{inspect(names)}"
    end
  end

  test "slug is the primary key, string typed, not nil-able" do
    slug = Ash.Resource.Info.attribute(Tag, :slug)
    assert slug.primary_key?
    assert slug.allow_nil? == false
    assert slug.type == Ash.Type.String
  end

  test "name and description use Multilingual type" do
    name = Ash.Resource.Info.attribute(Tag, :name)
    description = Ash.Resource.Info.attribute(Tag, :description)
    assert name.type == Alexandria.Types.Multilingual
    assert name.allow_nil? == false
    assert description.type == Alexandria.Types.Multilingual
  end

  test "metainfo defaults to empty map" do
    metainfo = Ash.Resource.Info.attribute(Tag, :metainfo)
    assert metainfo.type == Ash.Type.Map
    assert metainfo.default == %{}
  end

  test "create + update timestamps injected" do
    assert Ash.Resource.Info.attribute(Tag, :created_at)
    assert Ash.Resource.Info.attribute(Tag, :modified_at)
  end

  test "belongs_to :tag_synonym_group wired from alexandria_tag section" do
    rel = Ash.Resource.Info.relationship(Tag, :tag_synonym_group)
    assert rel.type == :belongs_to
    assert rel.destination == AlexandriaDev.Core.TagSynonymGroup
    assert rel.public?
  end

  test "default actions injected: read, create, rename, join/leave synonym group" do
    names = Tag |> Ash.Resource.Info.actions() |> Enum.map(& &1.name)
    for action <- [:read, :create, :rename, :join_synonym_group, :leave_synonym_group] do
      assert action in names, "expected action #{inspect(action)} in #{inspect(names)}"
    end
  end

  test ":create accepts slug, name, description, metainfo" do
    action = Ash.Resource.Info.action(Tag, :create)
    assert action.type == :create
    assert Enum.sort(action.accept) == Enum.sort([:slug, :name, :description, :metainfo])
  end

  test ":rename is an update accepting only name and description" do
    action = Ash.Resource.Info.action(Tag, :rename)
    assert action.type == :update
    assert Enum.sort(action.accept) == Enum.sort([:name, :description])
  end

  test ":join_synonym_group takes a :group_id uuid argument and is non-atomic" do
    action = Ash.Resource.Info.action(Tag, :join_synonym_group)
    assert action.type == :update
    assert action.require_atomic? == false
    assert [arg] = action.arguments
    assert arg.name == :group_id
    assert arg.type == Ash.Type.UUID
    assert arg.allow_nil? == false
  end

  test ":join_synonym_group has a manage_relationship change" do
    action = Ash.Resource.Info.action(Tag, :join_synonym_group)

    assert Enum.any?(action.changes, fn change ->
             match?(%{change: {Ash.Resource.Change.ManageRelationship, _}}, change)
           end)
  end

  test ":leave_synonym_group sets tag_synonym_group_id to nil" do
    action = Ash.Resource.Info.action(Tag, :leave_synonym_group)
    assert action.type == :update

    assert Enum.any?(action.changes, fn change ->
             case change.change do
               {Ash.Resource.Change.SetAttribute, opts} ->
                 Keyword.get(opts, :attribute) == :tag_synonym_group_id and
                   Keyword.get(opts, :value) == nil

               _ ->
                 false
             end
           end)
  end

  test "calculations :display_name and :display_description wired" do
    names = Tag |> Ash.Resource.Info.calculations() |> Enum.map(& &1.name)
    assert :display_name in names
    assert :display_description in names

    display_name = Ash.Resource.Info.calculation(Tag, :display_name)
    assert display_name.type == Ash.Type.String

    assert match?(
             {Alexandria.Calculations.LocalizedField, [attribute: :name]},
             display_name.calculation
           )
  end
end
