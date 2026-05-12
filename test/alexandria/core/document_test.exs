defmodule Alexandria.Core.DocumentTest do
  use Alexandria.DataCase, async: false
  alias Alexandria.Core.{Category, Document, Tag, Mark}

  setup do
    {:ok, cat} =
      Ash.create(
        Category,
        %{id: "intern", name: %{"en" => "Intern"}, color: "#000000"},
        action: :create_root,
        scope: admin_scope()
      )

    {:ok, %{category: cat}}
  end

  describe "create" do
    test "creates a document tied to a category", %{category: cat} do
      {:ok, d} =
        Ash.create(
          Document,
          %{
            title: %{"en" => "Doc1"},
            description: %{"en" => "Desc"},
            date: ~D[2026-05-12],
            category_id: cat.id
          },
          action: :create,
          scope: admin_scope()
        )

      assert d.title == %{"en" => "Doc1"}
      assert d.category_id == cat.id
    end
  end

  describe "reads" do
    test "list_by_category filters by category", %{category: cat} do
      {:ok, _} = create_doc(cat.id, "A")
      {:ok, _} = create_doc(cat.id, "B")

      {:ok, other} =
        Ash.create(
          Category,
          %{id: "other", name: %{"en" => "O"}, color: "#000000"},
          action: :create_root,
          scope: admin_scope()
        )

      {:ok, _} = create_doc(other.id, "C")

      titles =
        Document
        |> Ash.Query.for_read(:list_by_category, %{category_id: cat.id}, scope: admin_scope())
        |> Ash.read!()
        |> Enum.map(& &1.title["en"])

      assert Enum.sort(titles) == ["A", "B"]
    end

    test "by_tag filters by tag", %{category: cat} do
      {:ok, t} =
        Ash.create(Tag, %{id: "x", name: %{"en" => "X"}}, action: :create, scope: admin_scope())

      {:ok, d} = create_doc(cat.id, "A")
      {:ok, _} = create_doc(cat.id, "B")
      {:ok, _} = Ash.update(d, %{tag_id: t.id}, action: :add_tag, scope: admin_scope())

      titles =
        Document
        |> Ash.Query.for_read(:by_tag, %{tag_id: t.id}, scope: admin_scope())
        |> Ash.read!()
        |> Enum.map(& &1.title["en"])

      assert titles == ["A"]
    end
  end

  describe "mutations" do
    test "rename + edit_description + set_date", %{category: cat} do
      {:ok, d} = create_doc(cat.id, "A")

      {:ok, d} =
        Ash.update(d, %{title: %{"en" => "AA"}}, action: :rename, scope: admin_scope())

      {:ok, d} =
        Ash.update(d, %{description: %{"en" => "desc"}},
          action: :edit_description,
          scope: admin_scope()
        )

      {:ok, d} =
        Ash.update(d, %{date: ~D[2026-01-01]}, action: :set_date, scope: admin_scope())

      assert d.title == %{"en" => "AA"}
      assert d.description == %{"en" => "desc"}
      assert d.date == ~D[2026-01-01]
    end

    test "move_to_category", %{category: cat} do
      {:ok, other} =
        Ash.create(
          Category,
          %{id: "other", name: %{"en" => "O"}, color: "#000000"},
          action: :create_root,
          scope: admin_scope()
        )

      {:ok, d} = create_doc(cat.id, "A")

      {:ok, d2} =
        Ash.update(d, %{category_id: other.id},
          action: :move_to_category,
          scope: admin_scope()
        )

      assert d2.category_id == other.id
    end

    test "add_tag / remove_tag", %{category: cat} do
      {:ok, t} =
        Ash.create(Tag, %{id: "x", name: %{"en" => "X"}}, action: :create, scope: admin_scope())

      {:ok, d} = create_doc(cat.id, "A")
      {:ok, d} = Ash.update(d, %{tag_id: t.id}, action: :add_tag, scope: admin_scope())
      d = Ash.load!(d, [:tags], scope: admin_scope())
      assert [%{id: "x"}] = d.tags

      {:ok, d} = Ash.update(d, %{tag_id: t.id}, action: :remove_tag, scope: admin_scope())
      d = Ash.load!(d, [:tags], scope: admin_scope())
      assert d.tags == []
    end

    test "add_mark / remove_mark", %{category: cat} do
      {:ok, m} =
        Ash.create(Mark, %{id: "m", name: %{"en" => "M"}}, action: :create, scope: admin_scope())

      {:ok, d} = create_doc(cat.id, "A")
      {:ok, d} = Ash.update(d, %{mark_id: m.id}, action: :add_mark, scope: admin_scope())
      d = Ash.load!(d, [:marks], scope: admin_scope())
      assert [%{id: "m"}] = d.marks
    end

    test "archive sets metainfo.archived_at then restore clears it", %{category: cat} do
      {:ok, d} = create_doc(cat.id, "A")
      {:ok, d} = Ash.update(d, %{}, action: :archive, scope: admin_scope())
      assert Map.has_key?(d.metainfo, "archived_at")
      {:ok, d} = Ash.update(d, %{}, action: :restore, scope: admin_scope())
      refute Map.has_key?(d.metainfo, "archived_at")
    end

    test "destroy", %{category: cat} do
      {:ok, d} = create_doc(cat.id, "A")
      :ok = Ash.destroy!(d, action: :destroy, scope: admin_scope())
      assert {:error, _} = Ash.get(Document, d.id, scope: admin_scope())
    end

    test "upload creates document + initial file in one transaction", %{category: cat} do
      {:ok, d} =
        Ash.create(
          Document,
          %{
            title: %{"en" => "Doc1"},
            category_id: cat.id,
            file_name: "a.pdf",
            mime_type: "application/pdf",
            size: 5,
            bytes: "hello"
          },
          action: :upload,
          scope: admin_scope()
        )

      d = Ash.load!(d, [:files], scope: admin_scope())
      assert [%{name: "a.pdf", variant: :original} = f] = d.files
      assert Alexandria.Storage.exists?(f.content)
    end
  end

  defp create_doc(category_id, title) do
    Ash.create(
      Document,
      %{title: %{"en" => title}, category_id: category_id},
      action: :create,
      scope: admin_scope()
    )
  end
end
