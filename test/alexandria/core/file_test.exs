defmodule Alexandria.Core.FileTest do
  use Alexandria.DataCase, async: false

  setup do
    {:ok, cat} =
      Alexandria.Core.create_root_category(
        %{id: "intern", name: %{"en" => "Intern"}, color: "#000000"},
        scope: admin_scope()
      )

    {:ok, doc} =
      Alexandria.Core.create_document(
        %{title: %{"en" => "Doc1"}, category_id: cat.id},
        scope: admin_scope()
      )

    {:ok, %{document: doc}}
  end

  test "upload_original creates a File row + stores bytes", %{document: doc} do
    {:ok, f} =
      Alexandria.Core.upload_original_file(
        %{
          name: "file.pdf",
          mime_type: "application/pdf",
          size: 5,
          document_id: doc.id,
          bytes: "hello"
        },
        scope: admin_scope()
      )

    assert f.name == "file.pdf"
    assert f.variant == :original
    assert is_binary(f.content)
    assert Alexandria.Storage.exists?(f.content)
  end

  test "destroy removes both the row and the storage object", %{document: doc} do
    {:ok, f} =
      Alexandria.Core.upload_original_file(
        %{
          name: "f.pdf",
          mime_type: "application/pdf",
          size: 1,
          document_id: doc.id,
          bytes: "x"
        },
        scope: admin_scope()
      )

    key = f.content
    :ok = Alexandria.Core.destroy_file!(f, scope: admin_scope())
    refute Alexandria.Storage.exists?(key)
  end

  test "download_url returns a presigned URL", %{document: doc} do
    {:ok, f} =
      Alexandria.Core.upload_original_file(
        %{
          name: "f.pdf",
          mime_type: "application/pdf",
          size: 1,
          document_id: doc.id,
          bytes: "x"
        },
        scope: admin_scope()
      )

    assert {:ok, url} = Alexandria.Core.file_download_url(f.id, scope: admin_scope())
    assert is_binary(url)
  end
end
