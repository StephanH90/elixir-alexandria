defmodule AlexandriaDev.Core.TagSynonymGroupTest do
  @moduledoc """
  Asserts that `Alexandria.Core.Resource.TagSynonymGroup` injects the
  expected attributes, relationship, actions, and calculation into the
  consumer module `AlexandriaDev.Core.TagSynonymGroup`.
  """
  use ExUnit.Case, async: false

  alias AlexandriaDev.Core.TagSynonymGroup

  describe "attributes" do
    test "primary key is :id (uuid, required, public)" do
      id = Ash.Resource.Info.attribute(TagSynonymGroup, :id)
      assert id.primary_key?
      assert id.allow_nil? == false
      assert id.public?
      assert id.type == Ash.Type.UUID
    end

    test ":name is a required Multilingual attribute" do
      name = Ash.Resource.Info.attribute(TagSynonymGroup, :name)
      assert name.type == Alexandria.Types.Multilingual
      assert name.allow_nil? == false
      assert name.public?
    end
  end

  describe "relationships" do
    test "has_many :tags points at the consumer's Tag resource via :tag_synonym_group_id" do
      rel = Ash.Resource.Info.relationship(TagSynonymGroup, :tags)
      assert rel.type == :has_many
      assert rel.destination == AlexandriaDev.Core.Tag
      assert rel.destination_attribute == :tag_synonym_group_id
    end
  end

  describe "actions" do
    test ":read primary action is injected" do
      action = Ash.Resource.Info.primary_action(TagSynonymGroup, :read)
      assert action.name == :read
      assert action.type == :read
    end

    test ":create action accepts [:name]" do
      action = Ash.Resource.Info.action(TagSynonymGroup, :create)
      assert action.type == :create
      assert action.accept == [:name]
    end

    test ":rename update action accepts [:name]" do
      action = Ash.Resource.Info.action(TagSynonymGroup, :rename)
      assert action.type == :update
      assert action.accept == [:name]
    end

    test "no :destroy action is injected (ETS-compatible)" do
      refute Ash.Resource.Info.action(TagSynonymGroup, :destroy)
    end
  end

  describe "calculations" do
    test ":display_name uses LocalizedField on :name" do
      calc = Ash.Resource.Info.calculation(TagSynonymGroup, :display_name)
      assert calc.type == Ash.Type.String
      assert calc.calculation == {Alexandria.Calculations.LocalizedField, attribute: :name}
    end
  end
end
