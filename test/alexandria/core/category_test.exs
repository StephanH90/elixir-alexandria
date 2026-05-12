defmodule Alexandria.Core.CategoryTest do
  use Alexandria.DataCase, async: false

  alias Alexandria.Core.Category

  describe "create_root" do
    test "creates a root category with required attributes" do
      {:ok, cat} =
        Ash.create(
          Category,
          %{id: "intern", name: %{"en" => "Internal"}, color: "#FFFFFF"},
          action: :create_root,
          scope: admin_scope()
        )

      assert cat.id == "intern"
      assert cat.parent_id == nil
      assert cat.name == %{"en" => "Internal"}
      assert cat.color == "#FFFFFF"
      assert cat.sort == 0
    end

    test "rejects an invalid color" do
      assert {:error, _} =
               Ash.create(
                 Category,
                 %{id: "bad", name: %{"en" => "Bad"}, color: "not-a-color"},
                 action: :create_root,
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
        Ash.create(
          Category,
          %{id: "child", name: %{"en" => "C"}, color: "#000000", parent_id: "a-parent"},
          action: :create_child,
          scope: admin_scope()
        )

      ids =
        Category
        |> Ash.Query.for_read(:list_roots, %{}, scope: admin_scope())
        |> Ash.read!()
        |> Enum.map(& &1.id)

      assert ids == ["b", "a", "a-parent"]
    end
  end

  describe "list_children" do
    test "returns only the named parent's children" do
      {:ok, _} = create_root("p1")
      {:ok, _} = create_root("p2")

      {:ok, _} =
        Ash.create(
          Category,
          %{id: "c1", name: %{"en" => "C1"}, color: "#000000", parent_id: "p1"},
          action: :create_child,
          scope: admin_scope()
        )

      {:ok, _} =
        Ash.create(
          Category,
          %{id: "c2", name: %{"en" => "C2"}, color: "#000000", parent_id: "p2"},
          action: :create_child,
          scope: admin_scope()
        )

      ids =
        Category
        |> Ash.Query.for_read(:list_children, %{parent_id: "p1"}, scope: admin_scope())
        |> Ash.read!()
        |> Enum.map(& &1.id)

      assert ids == ["c1"]
    end
  end

  describe "mutations" do
    test "rename updates name + description" do
      {:ok, c} = create_root("a")

      {:ok, c2} =
        Ash.update(c, %{name: %{"en" => "Renamed"}, description: %{"en" => "d"}},
          action: :rename,
          scope: admin_scope()
        )

      assert c2.name == %{"en" => "Renamed"}
      assert c2.description == %{"en" => "d"}
    end

    test "recolor updates only color" do
      {:ok, c} = create_root("a")
      {:ok, c2} = Ash.update(c, %{color: "#AABBCC"}, action: :recolor, scope: admin_scope())
      assert c2.color == "#AABBCC"
    end

    test "reorder updates only sort" do
      {:ok, c} = create_root("a")
      {:ok, c2} = Ash.update(c, %{sort: 42}, action: :reorder, scope: admin_scope())
      assert c2.sort == 42
    end

    test "set_metainfo replaces metainfo" do
      {:ok, c} = create_root("a")

      {:ok, c2} =
        Ash.update(c, %{metainfo: %{"k" => "v"}}, action: :set_metainfo, scope: admin_scope())

      assert c2.metainfo == %{"k" => "v"}
    end

    test "destroy removes the category" do
      {:ok, c} = create_root("a")
      :ok = Ash.destroy!(c, action: :destroy, scope: admin_scope())
      assert {:error, _} = Ash.get(Category, "a", scope: admin_scope())
    end
  end

  defp create_root(id, opts \\ []) do
    Ash.create(
      Category,
      %{
        id: id,
        name: %{"en" => id},
        color: "#000000",
        sort: Keyword.get(opts, :sort)
      },
      action: :create_root,
      scope: admin_scope()
    )
  end
end
