defmodule Alexandria.Core.MarkTest do
  use Alexandria.DataCase, async: false
  alias Alexandria.Core.Mark

  test "lifecycle: create, rename, destroy" do
    {:ok, m} =
      Ash.create(Mark, %{id: "important", name: %{"en" => "Important"}},
        action: :create,
        scope: admin_scope()
      )

    {:ok, m2} =
      Ash.update(m, %{name: %{"en" => "Critical"}},
        action: :rename,
        scope: admin_scope()
      )

    assert m2.name == %{"en" => "Critical"}
    :ok = Ash.destroy!(m2, action: :destroy, scope: admin_scope())
  end
end
