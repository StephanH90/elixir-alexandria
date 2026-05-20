defmodule AlexandriaDev.Core.DocumentMarkTest do
  @moduledoc """
  Asserts that `Alexandria.Core.Resource.DocumentMark` injects the expected
  attributes, relationships, and actions into the consumer module
  `AlexandriaDev.Core.DocumentMark`.
  """
  use ExUnit.Case, async: false

  alias AlexandriaDev.Core.DocumentMark

  describe "attributes" do
    test "primary key is :id (uuid, required, public)" do
      id = Ash.Resource.Info.attribute(DocumentMark, :id)
      assert id.primary_key?
      assert id.allow_nil? == false
      assert id.public?
      assert id.type == Ash.Type.UUID
    end
  end

  describe "relationships" do
    test "belongs_to :document points at the consumer's Document resource" do
      rel = Ash.Resource.Info.relationship(DocumentMark, :document)
      assert rel.type == :belongs_to
      assert rel.destination == AlexandriaDev.Core.Document
      assert rel.allow_nil? == false
      assert rel.public?
    end

    test "belongs_to :mark points at the consumer's Mark resource via :slug" do
      rel = Ash.Resource.Info.relationship(DocumentMark, :mark)
      assert rel.type == :belongs_to
      assert rel.destination == AlexandriaDev.Core.Mark
      assert rel.destination_attribute == :slug
      assert rel.allow_nil? == false
      assert rel.public?
    end
  end

  describe "actions" do
    test ":read primary action is injected" do
      action = Ash.Resource.Info.primary_action(DocumentMark, :read)
      assert action.name == :read
      assert action.type == :read
    end

    test ":create primary action accepts all public attributes" do
      action = Ash.Resource.Info.action(DocumentMark, :create)
      assert action.type == :create
      assert action.primary?
    end

    test "primary :destroy action is injected" do
      action = Ash.Resource.Info.action(DocumentMark, :destroy)
      assert action.type == :destroy
      assert action.primary?
    end
  end
end
