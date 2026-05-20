defmodule AlexandriaDev.Application do
  use Application

  def start(_type, _args) do
    children = [
      AlexandriaDev.Repo,
      {Phoenix.PubSub, name: AlexandriaDev.PubSub},
      AlexandriaDevWeb.Endpoint
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: AlexandriaDev.Supervisor)
  end
end
