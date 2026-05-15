defmodule AlexandriaDevWeb.BrowserLive do
  use Phoenix.LiveView, layout: {AlexandriaDevWeb.Layouts, :root}

  import AlexandriaDevWeb.Components.Browser.CategoryNav
  import AlexandriaDevWeb.Components.Browser.DocumentList
  import AlexandriaDevWeb.Components.Browser.Search
  import AlexandriaDevWeb.Components.Browser.SidePanel
  import AlexandriaDevWeb.Components.Browser.Toolbar

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="alexandria-container uk-flex uk-flex-1 uk-height-1-1 uk-border uk-background-default">
      <.category_nav />
      <section class="uk-width-1 uk-flex uk-flex-column uk-overflow-hidden uk-height-max-1">
        <div class="uk-background-muted uk-padding-small uk-border-bottom uk-width-1">
          <.search_bar />
        </div>

        <div
          class="uk-flex uk-overflow-hidden uk-height-max-1 uk-height-1-1"
          data-test-document-view=""
          data-test-sort-key="title"
          data-test-sort-direction=""
        >
          <div class="uk-width-1 uk-flex uk-flex-column uk-overflow-hidden uk-height-max-1">
            <.toolbar />

            <div class="uk-padding-small uk-height-1-1 uk-overflow-auto document-grid--disallowed uk-border-top">
              <div class="document-view">
                <.document_list />
              </div>
              <!---->
            </div>
          </div>
          <.side_panel />
        </div>

        <div class="drag-info uk-background-default uk-box-shadow-medium uk-border-rounded uk-width-auto">
          0 Dokumente verschieben
        </div>
      </section>
    </div>
    """
  end
end
