defmodule AlexandriaDev.Core.MarkTest do
  @moduledoc """
  Asserts that `Alexandria.Core.Resource.Mark` injects the expected
  attributes, actions, and calculations into the consumer module
  `AlexandriaDev.Core.Mark`.
  """
  use ExUnit.Case, async: false

  alias AlexandriaDev.Core.Mark

  describe "attributes" do
    test "primary key is :slug (string, required, public)" do
      slug = Ash.Resource.Info.attribute(Mark, :slug)
      assert slug.primary_key?
      assert slug.allow_nil? == false
      assert slug.public?
      assert slug.type == Ash.Type.String
    end

    test ":name is a required Multilingual attribute" do
      name = Ash.Resource.Info.attribute(Mark, :name)
      assert name.type == Alexandria.Types.Multilingual
      assert name.allow_nil? == false
      assert name.public?
    end

    test ":description is an optional Multilingual attribute" do
      desc = Ash.Resource.Info.attribute(Mark, :description)
      assert desc.type == Alexandria.Types.Multilingual
      assert desc.public?
    end

    test ":metainfo is a map with default %{}" do
      meta = Ash.Resource.Info.attribute(Mark, :metainfo)
      assert meta.type == Ash.Type.Map
      assert meta.default == %{}
      assert meta.public?
    end

    test "created_by_user / created_by_group strings present" do
      assert %{type: Ash.Type.String} = Ash.Resource.Info.attribute(Mark, :created_by_user)
      assert %{type: Ash.Type.String} = Ash.Resource.Info.attribute(Mark, :created_by_group)
    end

    test "timestamps :created_at and :modified_at are present" do
      assert Ash.Resource.Info.attribute(Mark, :created_at)
      assert Ash.Resource.Info.attribute(Mark, :modified_at)
    end
  end

  describe "actions" do
    test ":read primary action is injected" do
      action = Ash.Resource.Info.primary_action(Mark, :read)
      assert action.name == :read
      assert action.type == :read
    end

    test ":create action accepts [:slug, :name, :description, :metainfo]" do
      action = Ash.Resource.Info.action(Mark, :create)
      assert action.type == :create
      assert Enum.sort(action.accept) == [:description, :metainfo, :name, :slug]
    end

    test ":rename update action accepts [:name, :description]" do
      action = Ash.Resource.Info.action(Mark, :rename)
      assert action.type == :update
      assert Enum.sort(action.accept) == [:description, :name]
    end
  end

  describe "calculations" do
    test ":display_name uses LocalizedField on :name" do
      calc = Ash.Resource.Info.calculation(Mark, :display_name)
      assert calc.type == Ash.Type.String
      assert calc.calculation == {Alexandria.Calculations.LocalizedField, attribute: :name}
    end

    test ":display_description uses LocalizedField on :description" do
      calc = Ash.Resource.Info.calculation(Mark, :display_description)
      assert calc.type == Ash.Type.String

      assert calc.calculation ==
               {Alexandria.Calculations.LocalizedField, attribute: :description}
    end
  end
end
