defmodule Alexandria.Core.TagTest do
  use Alexandria.DataCase, async: false

  test "lifecycle: create, rename, join group, leave group, destroy" do
    {:ok, t} =
      Alexandria.Core.create_tag(%{id: "urgent", name: %{"en" => "Urgent"}},
        scope: admin_scope()
      )

    {:ok, t2} =
      Alexandria.Core.rename_tag(t, %{name: %{"en" => "Very Urgent"}}, scope: admin_scope())

    assert t2.name == %{"en" => "Very Urgent"}

    {:ok, g} =
      Alexandria.Core.create_tag_synonym_group(%{name: %{"en" => "S"}},
        scope: admin_scope()
      )

    {:ok, t3} =
      Alexandria.Core.join_tag_synonym_group(t2, %{group_id: g.id}, scope: admin_scope())

    assert t3.tag_synonym_group_id == g.id

    {:ok, t4} = Alexandria.Core.leave_tag_synonym_group(t3, scope: admin_scope())
    assert t4.tag_synonym_group_id == nil

    :ok = Alexandria.Core.destroy_tag!(t4, scope: admin_scope())
  end
end
