defmodule Alexandria.Core.MarkTest do
  use Alexandria.DataCase, async: false

  test "lifecycle: create, rename, destroy" do
    {:ok, m} =
      Alexandria.Core.create_mark(%{slug: "important", name: %{"en" => "Important"}},
        scope: admin_scope()
      )

    {:ok, m2} =
      Alexandria.Core.rename_mark(m, %{name: %{"en" => "Critical"}}, scope: admin_scope())

    assert m2.name == %{"en" => "Critical"}
    :ok = Alexandria.Core.destroy_mark!(m2, scope: admin_scope())
  end
end
