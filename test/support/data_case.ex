defmodule Alexandria.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Alexandria.Repo
      alias Alexandria.Test.Scope

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Alexandria.DataCase
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Alexandria.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    :ok
  end

  def admin_scope do
    %Alexandria.Test.Scope{actor: %{id: "admin", roles: [:admin]}, locale: "en"}
  end
end
