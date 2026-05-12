defmodule Alexandria.Core.CategoryTest do
  use Alexandria.DataCase, async: false

  describe "create_root" do
    test "creates a root category with required attributes" do
      {:ok, cat} =
        Alexandria.Core.create_root_category(
          %{slug: "intern", name: %{"en" => "Internal"}, color: "#FFFFFF"},
          scope: admin_scope()
        )

      assert cat.slug == "intern"
      assert cat.parent_id == nil
      assert cat.name == %{"en" => "Internal"}
      assert cat.color == "#FFFFFF"
      assert cat.sort == 0
    end

    test "rejects an invalid color" do
      assert {:error, _} =
               Alexandria.Core.create_root_category(
                 %{slug: "bad", name: %{"en" => "Bad"}, color: "not-a-color"},
                 scope: admin_scope()
               )
    end
  end

  describe "list_roots" do
    test "returns only root categories sorted by :sort" do
      {:ok, _} = create_root("a", sort: 2)
      {:ok, _} = create_root("b", sort: 1)
      {:ok, _} = create_root("a-parent")

      {:ok, _} =
        Alexandria.Core.create_child_category(
          %{slug: "child", name: %{"en" => "C"}, color: "#000000", parent_id: "a-parent"},
          scope: admin_scope()
        )

      slugs =
        Alexandria.Core.list_root_categories!(scope: admin_scope())
        |> Enum.map(& &1.slug)

      assert slugs == ["b", "a", "a-parent"]
    end
  end

  describe "list_children" do
    test "returns only the named parent's children" do
      {:ok, _} = create_root("p1")
      {:ok, _} = create_root("p2")

      {:ok, _} =
        Alexandria.Core.create_child_category(
          %{slug: "c1", name: %{"en" => "C1"}, color: "#000000", parent_id: "p1"},
          scope: admin_scope()
        )

      {:ok, _} =
        Alexandria.Core.create_child_category(
          %{slug: "c2", name: %{"en" => "C2"}, color: "#000000", parent_id: "p2"},
          scope: admin_scope()
        )

      slugs =
        Alexandria.Core.list_child_categories!("p1", scope: admin_scope())
        |> Enum.map(& &1.slug)

      assert slugs == ["c1"]
    end
  end

  describe "mutations" do
    test "rename updates name + description" do
      {:ok, c} = create_root("a")

      {:ok, c2} =
        Alexandria.Core.rename_category(
          c,
          %{name: %{"en" => "Renamed"}, description: %{"en" => "d"}},
          scope: admin_scope()
        )

      assert c2.name == %{"en" => "Renamed"}
      assert c2.description == %{"en" => "d"}
    end

    test "recolor updates only color" do
      {:ok, c} = create_root("a")
      {:ok, c2} = Alexandria.Core.recolor_category(c, %{color: "#AABBCC"}, scope: admin_scope())
      assert c2.color == "#AABBCC"
    end

    test "reorder updates only sort" do
      {:ok, c} = create_root("a")
      {:ok, c2} = Alexandria.Core.reorder_category(c, %{sort: 42}, scope: admin_scope())
      assert c2.sort == 42
    end

    test "set_metainfo replaces metainfo" do
      {:ok, c} = create_root("a")

      {:ok, c2} =
        Alexandria.Core.set_category_metainfo(c, %{metainfo: %{"k" => "v"}}, scope: admin_scope())

      assert c2.metainfo == %{"k" => "v"}
    end

    test "destroy removes the category" do
      {:ok, c} = create_root("a")
      :ok = Alexandria.Core.destroy_category!(c, scope: admin_scope())
      assert {:error, _} = Alexandria.Core.get_category("a", scope: admin_scope())
    end
  end

  defp create_root(slug, opts \\ []) do
    Alexandria.Core.create_root_category(
      %{
        slug: slug,
        name: %{"en" => slug},
        color: "#000000",
        sort: Keyword.get(opts, :sort)
      },
      scope: admin_scope()
    )
  end
end
