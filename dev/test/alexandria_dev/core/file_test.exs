defmodule AlexandriaDev.Core.FileTest do
  @moduledoc """
  Proves the inverted `Alexandria.Core.Resource.File` extension compiles and
  injects the expected attributes, relationships, actions, and calculation.
  Structural assertions only — no DB, no S3.
  """
  use ExUnit.Case, async: false

  @resource AlexandriaDev.Core.File

  test "injects all attributes (including timestamps)" do
    names = @resource |> Ash.Resource.Info.attributes() |> Enum.map(& &1.name)

    for expected <- [
          :id,
          :name,
          :variant,
          :content,
          :mime_type,
          :size,
          :checksum,
          :metainfo,
          :created_by_user,
          :created_by_group,
          :created_at,
          :modified_at
        ] do
      assert expected in names, "expected #{inspect(expected)} in #{inspect(names)}"
    end
  end

  test ":id is the uuid primary key" do
    id = Ash.Resource.Info.attribute(@resource, :id)
    assert id.primary_key?
    assert id.type == Ash.Type.UUID
  end

  test ":variant is an atom with the documented one_of constraint" do
    variant = Ash.Resource.Info.attribute(@resource, :variant)
    assert variant.type == Ash.Type.Atom
    assert variant.default == :original
    refute variant.allow_nil?
    assert variant.constraints[:one_of] == [:original, :thumbnail, :rendering]
  end

  test "belongs_to :document points at the configured document_resource" do
    rel = Ash.Resource.Info.relationship(@resource, :document)
    assert rel.type == :belongs_to
    assert rel.destination == AlexandriaDev.Core.Document
    refute rel.allow_nil?
    assert rel.public?
  end

  test "belongs_to :original is a self-reference" do
    rel = Ash.Resource.Info.relationship(@resource, :original)
    assert rel.type == :belongs_to
    assert rel.destination == @resource
    assert rel.public?
  end

  test "injects the expected actions" do
    names = @resource |> Ash.Resource.Info.actions() |> Enum.map(& &1.name) |> Enum.sort()

    for expected <- [
          :download_url,
          :for_document,
          :read,
          :rename,
          :replace_content,
          :upload_original,
          :upload_rendering,
          :upload_thumbnail
        ] do
      assert expected in names, "expected #{inspect(expected)} in #{inspect(names)}"
    end
  end

  test ":read is the primary read action" do
    read = Ash.Resource.Info.primary_action(@resource, :read)
    assert read.name == :read
  end

  test ":for_document takes :document_id and filters on it" do
    action = Ash.Resource.Info.action(@resource, :for_document)
    assert action.type == :read
    arg_names = Enum.map(action.arguments, & &1.name)
    assert :document_id in arg_names
    assert action.filter != nil
  end

  test ":upload_original is a create with :bytes + :document_id arguments" do
    action = Ash.Resource.Info.action(@resource, :upload_original)
    assert action.type == :create
    arg_names = action.arguments |> Enum.map(& &1.name) |> Enum.sort()
    assert :bytes in arg_names
    assert :document_id in arg_names
    refute :original_id in arg_names
  end

  test ":upload_thumbnail requires :original_id" do
    action = Ash.Resource.Info.action(@resource, :upload_thumbnail)
    arg_names = Enum.map(action.arguments, & &1.name)
    assert :original_id in arg_names
  end

  test ":upload_rendering requires :original_id" do
    action = Ash.Resource.Info.action(@resource, :upload_rendering)
    arg_names = Enum.map(action.arguments, & &1.name)
    assert :original_id in arg_names
  end

  test ":rename is an update accepting only :name" do
    action = Ash.Resource.Info.action(@resource, :rename)
    assert action.type == :update
    assert action.accept == [:name]
  end

  test ":replace_content is non-atomic and takes :bytes" do
    action = Ash.Resource.Info.action(@resource, :replace_content)
    assert action.type == :update
    refute action.require_atomic?
    arg_names = Enum.map(action.arguments, & &1.name)
    assert :bytes in arg_names
  end

  test ":download_url is a generic action returning a string" do
    action = Ash.Resource.Info.action(@resource, :download_url)
    assert action.type == :action
    assert action.returns == Ash.Type.String
    arg_names = Enum.map(action.arguments, & &1.name)
    assert :id in arg_names
  end

  test ":display_size calculation is wired to HumanSize" do
    calc = Ash.Resource.Info.calculation(@resource, :display_size)
    assert calc != nil
    assert calc.type == Ash.Type.String

    assert match?(%Ash.Resource.Calculation{calculation: {Alexandria.Calculations.HumanSize, _}}, calc) or
             calc.calculation == Alexandria.Calculations.HumanSize or
             match?({Alexandria.Calculations.HumanSize, _}, calc.calculation)
  end
end
