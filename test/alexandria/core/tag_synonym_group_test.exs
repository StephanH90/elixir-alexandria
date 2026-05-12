defmodule Alexandria.Core.TagSynonymGroupTest do
  use Alexandria.DataCase, async: false
  alias Alexandria.Core.TagSynonymGroup

  test "create + rename + destroy" do
    {:ok, g} =
      Ash.create(TagSynonymGroup, %{name: %{"en" => "Synonyms"}},
        action: :create,
        scope: admin_scope()
      )

    {:ok, g2} =
      Ash.update(g, %{name: %{"en" => "Renamed"}},
        action: :rename,
        scope: admin_scope()
      )

    assert g2.name == %{"en" => "Renamed"}
    :ok = Ash.destroy!(g2, action: :destroy, scope: admin_scope())
  end
end
