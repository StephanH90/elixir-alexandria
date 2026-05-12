defmodule AlexandriaDevWeb.BrowserLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    scope = AlexandriaDev.demo_scope()

    cats =
      Alexandria.Core.Category
      |> Ash.Query.for_read(:list_roots, %{}, scope: scope)
      |> Ash.read!()

    {:ok, assign(socket, scope: scope, categories: cats, params: %{})}
  end

  def handle_params(params, _, socket), do: {:noreply, assign(socket, :params, params)}

  def render(assigns) do
    ~H"""
    <div class="uk-container uk-margin">
      <h1 class="uk-heading-divider">Alexandria Dev</h1>
      <ul>
        <li :for={c <- @categories}>
          {Alexandria.Types.Multilingual.get(c.name, @scope.locale)}
        </li>
      </ul>
    </div>
    """
  end
end
