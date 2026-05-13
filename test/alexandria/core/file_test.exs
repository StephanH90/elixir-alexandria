defmodule Alexandria.Core.FileTest do
  use Alexandria.DataCase, async: false

  setup do
    {:ok, cat} =
      Alexandria.Core.create_root_category(
        %{slug: "intern", name: %{"en" => "Intern"}, color: "#000000"},
        scope: admin_scope()
      )

    {:ok, doc} =
      Alexandria.Core.create_document(
        %{title: %{"en" => "Doc1"}, category_id: cat.slug},
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

  test "upload_thumbnail attaches a thumbnail to an original", %{document: doc} do
    {:ok, orig} =
      Alexandria.Core.upload_original_file(
        %{
          name: "o.pdf",
          mime_type: "application/pdf",
          size: 1,
          document_id: doc.id,
          bytes: "x"
        },
        scope: admin_scope()
      )

    {:ok, thumb} =
      Alexandria.Core.upload_thumbnail_file(
        %{
          name: "o.thumb.png",
          mime_type: "image/png",
          size: 1,
          document_id: doc.id,
          original_id: orig.id,
          bytes: "p"
        },
        scope: admin_scope()
      )

    assert thumb.variant == :thumbnail
    assert thumb.original_id == orig.id
    assert Alexandria.Storage.exists?(thumb.content)
  end

  test "upload_rendering attaches a rendering to an original", %{document: doc} do
    {:ok, orig} =
      Alexandria.Core.upload_original_file(
        %{
          name: "o.pdf",
          mime_type: "application/pdf",
          size: 1,
          document_id: doc.id,
          bytes: "x"
        },
        scope: admin_scope()
      )

    {:ok, rendering} =
      Alexandria.Core.upload_rendering_file(
        %{
          name: "o.rendering.pdf",
          mime_type: "application/pdf",
          size: 1,
          document_id: doc.id,
          original_id: orig.id,
          bytes: "r"
        },
        scope: admin_scope()
      )

    assert rendering.variant == :rendering
    assert rendering.original_id == orig.id
    assert Alexandria.Storage.exists?(rendering.content)
  end

  test "rename updates name without touching content", %{document: doc} do
    {:ok, f} =
      Alexandria.Core.upload_original_file(
        %{
          name: "old.pdf",
          mime_type: "application/pdf",
          size: 1,
          document_id: doc.id,
          bytes: "x"
        },
        scope: admin_scope()
      )

    {:ok, f2} = Alexandria.Core.rename_file(f, %{name: "new.pdf"}, scope: admin_scope())

    assert f2.name == "new.pdf"
    assert f2.content == f.content
    assert Alexandria.Storage.exists?(f.content)
  end

  test "replace_content writes a new object and deletes the old one", %{document: doc} do
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

    old_key = f.content

    {:ok, f2} =
      Alexandria.Core.replace_file_content(
        f,
        %{mime_type: "application/pdf", size: 2, bytes: "yy"},
        scope: admin_scope()
      )

    assert f2.content != old_key
    assert Alexandria.Storage.exists?(f2.content)
    refute Alexandria.Storage.exists?(old_key)
  end

  test "upload_original rolls back the DB row when storage put fails", %{document: doc} do
    # Configure storage to refuse puts for this test
    prior = Application.get_env(:alexandria, :storage)
    Application.put_env(:alexandria, :storage, adapter: Alexandria.Test.AlwaysFailStorage)
    on_exit(fn -> Application.put_env(:alexandria, :storage, prior) end)

    files_before = Alexandria.Core.list_files_for_document!(doc.id, scope: admin_scope())

    assert {:error, _} =
             Alexandria.Core.upload_original_file(
               %{
                 name: "x.pdf",
                 mime_type: "application/pdf",
                 size: 1,
                 document_id: doc.id,
                 bytes: "x"
               },
               scope: admin_scope()
             )

    files_after = Alexandria.Core.list_files_for_document!(doc.id, scope: admin_scope())
    assert length(files_after) == length(files_before)
  end
end
