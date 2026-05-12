defmodule AlexandriaDevWeb.BrowserLive do
  use Phoenix.LiveView, layout: {AlexandriaDevWeb.Layouts, :root}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, scope: AlexandriaDev.demo_scope(), params: %{})}
  end

  @impl true
  def handle_params(params, _, socket), do: {:noreply, assign(socket, :params, params)}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="uk-container uk-margin">
      <h1 class="uk-heading-divider">Alexandria Dev</h1>
      <.live_component module={AlexandriaWeb.Browser} id="b" scope={@scope} params={@params} />
    </div>
    """
  end
end
