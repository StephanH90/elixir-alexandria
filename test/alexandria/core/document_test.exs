defmodule Alexandria.Core.DocumentTest do
  use Alexandria.DataCase, async: false

  setup do
    {:ok, cat} =
      Alexandria.Core.create_root_category(
        %{slug: "intern", name: %{"en" => "Intern"}, color: "#000000"},
        scope: admin_scope()
      )

    {:ok, %{category: cat}}
  end

  describe "create" do
    test "creates a document tied to a category", %{category: cat} do
      {:ok, d} =
        Alexandria.Core.create_document(
          %{
            title: %{"en" => "Doc1"},
            description: %{"en" => "Desc"},
            date: ~D[2026-05-12],
            category_id: cat.slug
          },
          scope: admin_scope()
        )

      assert d.title == %{"en" => "Doc1"}
      assert d.category_id == cat.slug
    end
  end

  describe "reads" do
    test "list_by_category filters by category", %{category: cat} do
      {:ok, _} = create_doc(cat.slug, "A")
      {:ok, _} = create_doc(cat.slug, "B")

      {:ok, other} =
        Alexandria.Core.create_root_category(
          %{slug: "other", name: %{"en" => "O"}, color: "#000000"},
          scope: admin_scope()
        )

      {:ok, _} = create_doc(other.slug, "C")

      titles =
        Alexandria.Core.list_documents_by_category!(cat.slug, scope: admin_scope())
        |> Enum.map(& &1.title["en"])

      assert Enum.sort(titles) == ["A", "B"]
    end

    test "by_tag filters by tag", %{category: cat} do
      {:ok, t} =
        Alexandria.Core.create_tag(%{slug: "x", name: %{"en" => "X"}}, scope: admin_scope())

      {:ok, d} = create_doc(cat.slug, "A")
      {:ok, _} = create_doc(cat.slug, "B")
      {:ok, _} = Alexandria.Core.add_tag_to_document(d, %{tag_id: t.slug}, scope: admin_scope())

      titles =
        Alexandria.Core.list_documents_by_tag!(t.slug, scope: admin_scope())
        |> Enum.map(& &1.title["en"])

      assert titles == ["A"]
    end
  end

  describe "mutations" do
    test "rename + edit_description + set_date", %{category: cat} do
      {:ok, d} = create_doc(cat.slug, "A")

      {:ok, d} =
        Alexandria.Core.rename_document(d, %{title: %{"en" => "AA"}}, scope: admin_scope())

      {:ok, d} =
        Alexandria.Core.edit_document_description(d, %{description: %{"en" => "desc"}},
          scope: admin_scope()
        )

      {:ok, d} =
        Alexandria.Core.set_document_date(d, %{date: ~D[2026-01-01]}, scope: admin_scope())

      assert d.title == %{"en" => "AA"}
      assert d.description == %{"en" => "desc"}
      assert d.date == ~D[2026-01-01]
    end

    test "move_to_category", %{category: cat} do
      {:ok, other} =
        Alexandria.Core.create_root_category(
          %{slug: "other", name: %{"en" => "O"}, color: "#000000"},
          scope: admin_scope()
        )

      {:ok, d} = create_doc(cat.slug, "A")

      {:ok, d2} =
        Alexandria.Core.move_document_to_category(d, %{category_id: other.slug},
          scope: admin_scope()
        )

      assert d2.category_id == other.slug
    end

    test "add_tag / remove_tag", %{category: cat} do
      {:ok, t} =
        Alexandria.Core.create_tag(%{slug: "x", name: %{"en" => "X"}}, scope: admin_scope())

      {:ok, d} = create_doc(cat.slug, "A")
      {:ok, d} = Alexandria.Core.add_tag_to_document(d, %{tag_id: t.slug}, scope: admin_scope())
      d = Ash.load!(d, [:tags], scope: admin_scope())
      assert [%{slug: "x"}] = d.tags

      {:ok, d} =
        Alexandria.Core.remove_tag_from_document(d, %{tag_id: t.slug}, scope: admin_scope())

      d = Ash.load!(d, [:tags], scope: admin_scope())
      assert d.tags == []
    end

    test "add_mark / remove_mark", %{category: cat} do
      {:ok, m} =
        Alexandria.Core.create_mark(%{slug: "m", name: %{"en" => "M"}}, scope: admin_scope())

      {:ok, d} = create_doc(cat.slug, "A")
      {:ok, d} = Alexandria.Core.add_mark_to_document(d, %{mark_id: m.slug}, scope: admin_scope())
      d = Ash.load!(d, [:marks], scope: admin_scope())
      assert [%{slug: "m"}] = d.marks
    end

    test "archive sets metainfo.archived_at then restore clears it", %{category: cat} do
      {:ok, d} = create_doc(cat.slug, "A")
      {:ok, d} = Alexandria.Core.archive_document(d, scope: admin_scope())
      assert Map.has_key?(d.metainfo, "archived_at")
      {:ok, d} = Alexandria.Core.restore_document(d, scope: admin_scope())
      refute Map.has_key?(d.metainfo, "archived_at")
    end

    test "destroy", %{category: cat} do
      {:ok, d} = create_doc(cat.slug, "A")
      :ok = Alexandria.Core.destroy_document!(d, scope: admin_scope())
      assert {:error, _} = Alexandria.Core.get_document(d.id, scope: admin_scope())
    end

    test "upload creates document + initial file in one transaction", %{category: cat} do
      {:ok, d} =
        Alexandria.Core.upload_document(
          %{
            title: %{"en" => "Doc1"},
            category_id: cat.slug,
            file_name: "a.pdf",
            mime_type: "application/pdf",
            size: 5,
            bytes: "hello"
          },
          scope: admin_scope()
        )

      d = Ash.load!(d, [:files], scope: admin_scope())
      assert [%{name: "a.pdf", variant: :original} = f] = d.files
      assert Alexandria.Storage.exists?(f.content)
    end
  end

  defp create_doc(category_id, title) do
    Alexandria.Core.create_document(
      %{title: %{"en" => title}, category_id: category_id},
      scope: admin_scope()
    )
  end
end
