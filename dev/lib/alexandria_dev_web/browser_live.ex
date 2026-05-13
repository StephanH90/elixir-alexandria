defmodule AlexandriaDevWeb.BrowserLive do
  use Phoenix.LiveView, layout: {AlexandriaDevWeb.Layouts, :root}

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <div style="padding: 2rem; font-family: system-ui;">
      <h1>Alexandria dev shell</h1>
      <p>Browser UI removed. Replace this page with a new component.</p>
    </div>
    """
  end
end
