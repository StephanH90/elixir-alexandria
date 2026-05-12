defmodule Alexandria.Core.TagSynonymGroupTest do
  use Alexandria.DataCase, async: false

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
