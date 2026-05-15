defmodule AlexandriaDevWeb.BrowserLive do
  use Phoenix.LiveView, layout: {AlexandriaDevWeb.Layouts, :root} # todo: this is old syntax
  use Phoenix.VerifiedRoutes, endpoint: AlexandriaDevWeb.Endpoint, router: AlexandriaDevWeb.Router # todo: this needs to be injected or loaded dynamically in this addon

  import AlexandriaDevWeb.Components.Browser.CategoryNav
  import AlexandriaDevWeb.Components.Browser.DocumentList
  import AlexandriaDevWeb.Components.Browser.Search
  import AlexandriaDevWeb.Components.Browser.SidePanel
  import AlexandriaDevWeb.Components.Browser.Toolbar

  @impl true
  def render(assigns) do
    ~H"""
    <div class="alexandria-container uk-flex uk-flex-1 uk-height-1-1 uk-border uk-background-default">
      <.category_nav categories={@categories} active_category={@active_category} />
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
                <.document_list documents={@documents}/>
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

  @impl true
  def mount(_params, _session, socket) do
    scope = %AlexandriaDev.Scope{locale: "de-ch", actor: %{role: :support}}
    categories = Alexandria.Core.list_root_categories!(scope: scope, load: :active_document_count)

    socket = assign(socket, categories: categories, active_category: get_active_category(categories), scope: scope)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"category" => category}, _session, socket) do
    # todo fetch documents
    active_category = get_active_category(socket.assigns.categories, category)
    documents = Alexandria.Core.list_active_documents_by_category!(active_category.slug, scope: socket.assigns.scope, load: :category)

    socket = assign(socket, documents: documents, active_category: active_category)

    {:noreply, socket}
  end

  @impl true
  def handle_params(_params, _session, socket), do: {:noreply, socket}

  @impl true
  def handle_event("alexandria:navigate", %{"category" => category}, socket) do
    {:noreply, push_patch(socket, to: ~p"/?#{[category: category]}")}
  end

  defp get_active_category([first_category | _rest]), do: first_category
  defp get_active_category(categories, category_slug) do
    Enum.find(categories, fn cat -> cat.slug == category_slug end)
  end
end
