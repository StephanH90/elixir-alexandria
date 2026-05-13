defmodule Alexandria.Core.TagSynonymGroupTest do
  use Alexandria.DataCase, async: false

  test "tags belonging to a group are reachable via the `tags` relation" do
    {:ok, g} =
      Alexandria.Core.create_tag_synonym_group(%{name: %{"en" => "Synonyms"}},
        scope: admin_scope()
      )

    {:ok, t1} =
      Alexandria.Core.create_tag(%{slug: "fast", name: %{"en" => "Fast"}}, scope: admin_scope())

    {:ok, t2} =
      Alexandria.Core.create_tag(%{slug: "quick", name: %{"en" => "Quick"}}, scope: admin_scope())

    {:ok, _} = Alexandria.Core.join_tag_synonym_group(t1, %{group_id: g.id}, scope: admin_scope())
    {:ok, _} = Alexandria.Core.join_tag_synonym_group(t2, %{group_id: g.id}, scope: admin_scope())

    g = Ash.load!(g, [:tags], scope: admin_scope())

    assert Enum.map(g.tags, & &1.slug) |> Enum.sort() == ["fast", "quick"]
  end

  test "create + rename + destroy" do
    {:ok, g} =
      Alexandria.Core.create_tag_synonym_group(%{name: %{"en" => "Synonyms"}},
        scope: admin_scope()
      )

    {:ok, g2} =
      Alexandria.Core.rename_tag_synonym_group(g, %{name: %{"en" => "Renamed"}},
        scope: admin_scope()
      )

    assert g2.name == %{"en" => "Renamed"}
    :ok = Alexandria.Core.destroy_tag_synonym_group!(g2, scope: admin_scope())
  end
end
