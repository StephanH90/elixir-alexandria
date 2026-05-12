defmodule AlexandriaWeb.Browser do
  @moduledoc """
  Embeddable LiveComponent that renders Alexandria's category tree,
  document list, and document detail panel.

  Assigns required from host:
  - `scope` — Phoenix 1.8 scope; lib reads `scope.actor` and `scope.locale`
  - `params` — `socket.assigns.params` from the host LiveView's `handle_params/3`

  URL state convention (host LV owns the path; component owns the query string):
  - `?category=<slug>` — selected category
  - `?document=<uuid>,<uuid>,...` — open documents (multi-select)
  - `?sort=...`, `?page=...`, `?q=...` — read-list controls (display-only this task)
  """
  use Phoenix.LiveComponent

  alias Alexandria.Types.Multilingual

  @impl true
  def update(assigns, socket) do
    scope = assigns.scope
    params = assigns.params || %{}
    locale = scope.locale || "en"
    selected_category = params["category"]
    selected_documents = decode_ids(params["document"])

    categories = Alexandria.Core.list_root_categories!(scope: scope)

    documents =
      case selected_category do
        nil -> []
        slug -> Alexandria.Core.list_documents_by_category!(slug, scope: scope)
      end

    open_documents =
      case selected_documents do
        [] -> []
        ids -> Alexandria.Core.list_documents_by_ids!(ids, scope: scope)
      end

    {:ok,
     assign(socket,
       scope: scope,
       params: params,
       locale: locale,
       selected_category: selected_category,
       selected_documents: selected_documents,
       categories: categories,
       documents: documents,
       open_documents: open_documents
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="uk-grid uk-grid-collapse" uk-grid>
      <aside class="uk-width-1-5">
        <ul class="uk-nav uk-nav-default">
          <li :for={c <- @categories} class={if @selected_category == c.slug, do: "uk-active"}>
            <.link patch={category_path(@params, c.slug)}>
              {Multilingual.get(c.name, @locale)}
            </.link>
          </li>
        </ul>
      </aside>

      <main class="uk-width-2-5">
        <h3 :if={!@selected_category}>Select a category</h3>
        <ul :if={@selected_category} class="uk-list uk-list-divider">
          <li :for={d <- @documents}>
            <.link patch={document_path(@params, d.id)}>
              {Multilingual.get(d.title, @locale)}
            </.link>
          </li>
        </ul>
      </main>

      <section class="uk-width-2-5">
        <article
          :for={d <- @open_documents}
          class="uk-card uk-card-default uk-card-body uk-margin-small-bottom"
        >
          <h4>{Multilingual.get(d.title, @locale)}</h4>
          <p :if={d.description}>{Multilingual.get(d.description, @locale)}</p>
          <small :if={d.date}>{d.date}</small>
        </article>
      </section>
    </div>
    """
  end

  defp decode_ids(nil), do: []
  defp decode_ids(""), do: []
  defp decode_ids(str), do: String.split(str, ",", trim: true)

  defp category_path(params, slug) do
    "?" <> URI.encode_query(Map.put(params, "category", slug))
  end

  defp document_path(params, id) do
    current = decode_ids(params["document"])
    new_value = (current ++ [id]) |> Enum.uniq() |> Enum.join(",")
    "?" <> URI.encode_query(Map.put(params, "document", new_value))
  end
end
