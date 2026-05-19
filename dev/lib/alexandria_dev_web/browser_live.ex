defmodule AlexandriaDevWeb.BrowserLive do
  # todo: this is old syntax
  use Phoenix.LiveView, layout: {AlexandriaDevWeb.Layouts, :root}
  # todo: this needs to be injected or loaded dynamically in this addon
  use Phoenix.VerifiedRoutes, endpoint: AlexandriaDevWeb.Endpoint, router: AlexandriaDevWeb.Router

  import AlexandriaDevWeb.Components.Browser.CategoryNav
  import AlexandriaDevWeb.Components.Browser.DocumentList
  import AlexandriaDevWeb.Components.Browser.Search
  import AlexandriaDevWeb.Components.Browser.SidePanel
  import AlexandriaDevWeb.Components.Browser.Toolbar

  @impl true
  def mount(_params, _session, socket) do
    scope = %AlexandriaDev.Scope{locale: "de-ch", actor: %{role: :foobar}}
    categories = Alexandria.Core.list_root_categories!(scope: scope, load: :active_document_count)

    socket =
      assign(socket,
        categories: categories,
        active_category: get_active_category(categories, nil),
        scope: scope
      )

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _session, socket) do
    active_category = get_active_category(socket.assigns.categories, params["category"])
    sort = params["sort"] || "-title"

    documents =
      Alexandria.Core.list_active_documents_by_category!(active_category.slug,
        scope: socket.assigns.scope,
        load: [:category, :tags_slugs],
        query: [sort: Ash.Sort.parse_input!(Alexandria.Core.Document, sort)]
      )
      |> dbg()

    socket =
      assign(socket,
        documents: documents,
        active_category: active_category,
        current_sort: sort,
        query_params: params,
        selected_documents: params["selected"] || []
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("alexandria:navigate", params, socket) do
    params =
      socket.assigns.query_params
      |> Map.merge(params)
      |> Map.delete("selected")

    {:noreply, push_patch(socket, to: ~p"/?#{params}")}
  end

  @impl true
  def handle_event("alexandria:update-sort", params, socket) do
    params = Map.merge(socket.assigns.query_params, params)
    {:noreply, push_patch(socket, to: ~p"/?#{params}")}
  end

  @impl true
  def handle_event("alexandria:document-selected", %{"id" => clicked_id} = params, socket) do
    selection = socket.assigns.query_params["selected"] || []
    new_selection = update_selection(params, clicked_id, selection, socket.assigns.documents)
    query = Map.put(socket.assigns.query_params, "selected", new_selection)
    {:noreply, push_patch(socket, to: ~p"/?#{query}")}
  end

  @impl true
  def handle_info({:alexandria_document_updated, updated_document}, socket) do
    documents =
      Enum.map(socket.assigns.documents, fn
        %{id: id} = doc -> if id == updated_document.id, do: updated_document, else: doc
      end)

    {:noreply, assign(socket, :documents, documents)}
  end

  defp update_selection(%{"shiftKey" => true}, clicked_id, selection, docs),
    do: range_select(selection, clicked_id, docs)

  defp update_selection(%{"ctrlKey" => true}, clicked_id, selection, _docs),
    do: toggle(selection, clicked_id)

  defp update_selection(_, clicked_id, _selection, _docs), do: [clicked_id]

  defp toggle(selection, clicked_id) do
    if clicked_id in selection,
      do: List.delete(selection, clicked_id),
      else: selection ++ [clicked_id]
  end

  defp range_select([], clicked_id, _documents), do: [clicked_id]

  defp range_select(selection, clicked_id, documents) do
    document_ids = Enum.map(documents, & &1.id)
    anchor = List.last(selection)
    i_anchor = Enum.find_index(document_ids, &(&1 == anchor))
    i_clicked = Enum.find_index(document_ids, &(&1 == clicked_id))

    if i_anchor && i_clicked do
      {lo, hi} = Enum.min_max([i_anchor, i_clicked])
      range = Enum.slice(document_ids, lo..hi)
      # anchor must remain last so the next shift-click pivots from the original click
      (selection -- range) ++ (range -- [anchor]) ++ [anchor]
    else
      selection ++ [clicked_id]
    end
  end

  defp get_active_category([first_category | _rest], nil), do: first_category

  defp get_active_category(categories, category_slug) do
    Enum.find(categories, fn cat -> cat.slug == category_slug end)
  end

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
                <.document_list
                  documents={@documents}
                  current_sort={@current_sort}
                  selected_documents={@selected_documents}
                />
              </div>
              <!---->
            </div>
          </div>
          <!-- <.side_panel selected_documents={@selected_documents} documents={@documents} /> -->
          <.live_component
            module={AlexandriaDevWeb.Components.Browser.SidePanel}
            id="side-panel"
            documents={@documents}
            selected_documents={@selected_documents}
            scope={@scope}
          />
        </div>

        <div class="drag-info uk-background-default uk-box-shadow-medium uk-border-rounded uk-width-auto">
          0 Dokumente verschieben
        </div>
      </section>
    </div>
    """
  end
end
