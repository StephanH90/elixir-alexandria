defmodule Alexandria.Core.FileTest do
  use Alexandria.DataCase, async: false
  alias Alexandria.Core.{Category, Document, File}

  setup do
    {:ok, cat} =
      Ash.create(
        Category,
        %{id: "intern", name: %{"en" => "Intern"}, color: "#000000"},
        action: :create_root,
        scope: admin_scope()
      )

    {:ok, doc} =
      Ash.create(
        Document,
        %{title: %{"en" => "Doc1"}, category_id: cat.id},
        action: :create,
        scope: admin_scope()
      )

    {:ok, %{document: doc}}
  end

  test "upload_original creates a File row + stores bytes", %{document: doc} do
    {:ok, f} =
      Ash.create(
        File,
        %{
          name: "file.pdf",
          mime_type: "application/pdf",
          size: 5,
          document_id: doc.id,
          bytes: "hello"
        },
        action: :upload_original,
        scope: admin_scope()
      )

    assert f.name == "file.pdf"
    assert f.variant == :original
    assert is_binary(f.content)
    assert Alexandria.Storage.exists?(f.content)
  end

  test "destroy removes both the row and the storage object", %{document: doc} do
    {:ok, f} =
      Ash.create(
        File,
        %{
          name: "f.pdf",
          mime_type: "application/pdf",
          size: 1,
          document_id: doc.id,
          bytes: "x"
        },
        action: :upload_original,
        scope: admin_scope()
      )

    key = f.content
    :ok = Ash.destroy!(f, action: :destroy, scope: admin_scope())
    refute Alexandria.Storage.exists?(key)
  end

  test "download_url returns a presigned URL", %{document: doc} do
    {:ok, f} =
      Ash.create(
        File,
        %{
          name: "f.pdf",
          mime_type: "application/pdf",
          size: 1,
          document_id: doc.id,
          bytes: "x"
        },
        action: :upload_original,
        scope: admin_scope()
      )

    input = Ash.ActionInput.for_action(File, :download_url, %{id: f.id}, scope: admin_scope())
    assert {:ok, url} = Ash.run_action(input)
    assert is_binary(url)
  end
end
