defmodule AlexandriaDev.Core.DocumentTagTest do
  @moduledoc """
  Asserts that `Alexandria.Core.Resource.DocumentTag` injects the expected
  attributes, relationships, and actions into the consumer module
  `AlexandriaDev.Core.DocumentTag`.
  """
  use ExUnit.Case, async: false

  alias AlexandriaDev.Core.DocumentTag

  describe "attributes" do
    test "primary key is :id (uuid, required, public)" do
      id = Ash.Resource.Info.attribute(DocumentTag, :id)
      assert id.primary_key?
      assert id.allow_nil? == false
      assert id.public?
      assert id.type == Ash.Type.UUID
    end
  end

  describe "relationships" do
    test "belongs_to :document points at the consumer's Document resource" do
      rel = Ash.Resource.Info.relationship(DocumentTag, :document)
      assert rel.type == :belongs_to
      assert rel.destination == AlexandriaDev.Core.Document
      assert rel.allow_nil? == false
      assert rel.public?
    end

    test "belongs_to :tag points at the consumer's Tag resource via :slug" do
      rel = Ash.Resource.Info.relationship(DocumentTag, :tag)
      assert rel.type == :belongs_to
      assert rel.destination == AlexandriaDev.Core.Tag
      assert rel.destination_attribute == :slug
      assert rel.allow_nil? == false
      assert rel.public?
    end
  end

  describe "actions" do
    test ":read primary action is injected" do
      action = Ash.Resource.Info.primary_action(DocumentTag, :read)
      assert action.name == :read
      assert action.type == :read
    end

    test ":create primary action accepts all public attributes" do
      action = Ash.Resource.Info.action(DocumentTag, :create)
      assert action.type == :create
      assert action.primary?
    end

    test "primary :destroy action is injected" do
      action = Ash.Resource.Info.action(DocumentTag, :destroy)
      assert action.type == :destroy
      assert action.primary?
    end
  end
end
