defmodule Alexandria.Core.TagTest do
  use Alexandria.DataCase, async: false
  alias Alexandria.Core.{Tag, TagSynonymGroup}

  test "lifecycle: create, rename, join group, leave group, destroy" do
    {:ok, t} =
      Ash.create(Tag, %{id: "urgent", name: %{"en" => "Urgent"}},
        action: :create,
        scope: admin_scope()
      )

    {:ok, t2} =
      Ash.update(t, %{name: %{"en" => "Very Urgent"}},
        action: :rename,
        scope: admin_scope()
      )

    assert t2.name == %{"en" => "Very Urgent"}

    {:ok, g} =
      Ash.create(TagSynonymGroup, %{name: %{"en" => "S"}},
        action: :create,
        scope: admin_scope()
      )

    {:ok, t3} =
      Ash.update(t2, %{group_id: g.id},
        action: :join_synonym_group,
        scope: admin_scope()
      )

    assert t3.tag_synonym_group_id == g.id

    {:ok, t4} = Ash.update(t3, %{}, action: :leave_synonym_group, scope: admin_scope())
    assert t4.tag_synonym_group_id == nil

    :ok = Ash.destroy!(t4, action: :destroy, scope: admin_scope())
  end
end
