defmodule Alexandria.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [Alexandria.Repo] ++ storage_children()

    opts = [strategy: :one_for_one, name: Alexandria.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp storage_children do
    case Application.get_env(:alexandria, :storage)[:adapter] do
      Alexandria.Storage.InMemory -> [Alexandria.Storage.InMemory]
      _ -> []
    end
  end
end
