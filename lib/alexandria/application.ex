defmodule Alexandria.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [Alexandria.Repo]

    opts = [strategy: :one_for_one, name: Alexandria.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
