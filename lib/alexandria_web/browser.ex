defmodule AlexandriaWeb.Browser do
  @moduledoc """
  Embeddable LiveComponent: category tree + document list + detail panel.
  Host LV passes `scope` + `params`; component owns URL mutations via push_patch.
  """
  use Phoenix.LiveComponent

  alias Alexandria.Types.Multilingual

  @impl true
  def mount(socket) do
    {:ok, allow_upload(socket, :file, accept: :any, max_entries: 1)}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, load_state(socket, assigns.scope, assigns.params || %{})}
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

        <div :if={@selected_category}>
          <.form
            for={%{}}
            as={:upload}
            phx-submit="upload"
            phx-change="validate_upload"
            phx-target={@myself}
            multipart={true}
            class="uk-margin"
          >
            <label for="upload_title" class="uk-form-label">Title</label>
            <input
              id="upload_title"
              name="upload[title]"
              class="uk-input uk-margin-small-bottom"
              required
            />
            <label for={@uploads.file.ref} class="uk-form-label">File</label>
            <.live_file_input upload={@uploads.file} class="uk-margin-small-bottom" required />
            <button type="submit" class="uk-button uk-button-primary uk-button-small">Upload</button>
          </.form>

          <ul class="uk-list uk-list-divider">
            <li :for={d <- @documents}>
              <.link patch={document_path(@params, d.id)}>
                {Multilingual.get(d.title, @locale)}
              </.link>
            </li>
          </ul>
        </div>
      </main>

      <section class="uk-width-2-5">
        <article
          :for={d <- @open_documents}
          class="uk-card uk-card-default uk-card-body uk-margin-small-bottom"
        >
          <h4>{Multilingual.get(d.title, @locale)}</h4>

          <.form
            for={%{}}
            as={:rename}
            phx-submit="rename"
            phx-target={@myself}
            phx-value-id={d.id}
          >
            <input
              name="rename[title]"
              type="text"
              value={Multilingual.get(d.title, @locale)}
              class="uk-input uk-margin-small-bottom"
            />
            <button type="submit" class="uk-button uk-button-primary uk-button-small">Save</button>
          </.form>

          <button
            class="uk-button uk-button-danger uk-button-small uk-margin-small-top"
            phx-click="delete"
            phx-target={@myself}
            phx-value-id={d.id}
          >
            Delete
          </button>
        </article>
      </section>
    </div>
    """
  end

  @impl true
  def handle_event("rename", %{"id" => id, "rename" => %{"title" => new_title}}, socket) do
    scope = socket.assigns.scope
    locale = socket.assigns.locale
    {:ok, doc} = Alexandria.Core.get_document(id, scope: scope)

    {:ok, _} =
      Alexandria.Core.rename_document(
        doc,
        %{title: Map.put(doc.title, locale, new_title)},
        scope: scope
      )

    {:noreply, load_state(socket, scope, socket.assigns.params)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    scope = socket.assigns.scope
    {:ok, doc} = Alexandria.Core.get_document(id, scope: scope)
    :ok = Alexandria.Core.destroy_document!(doc, scope: scope)

    remaining = Enum.reject(socket.assigns.selected_documents, &(&1 == id))
    new_params = update_document_param(socket.assigns.params, remaining)

    {:noreply, push_patch(socket, to: "/?" <> URI.encode_query(new_params))}
  end

  def handle_event("validate_upload", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("upload", %{"upload" => %{"title" => title}}, socket) do
    scope = socket.assigns.scope
    locale = socket.assigns.locale

    [{filename, mime, bytes}] =
      consume_uploaded_entries(socket, :file, fn %{path: path}, entry ->
        {:ok, {entry.client_name, entry.client_type, File.read!(path)}}
      end)

    {:ok, _doc} =
      Alexandria.Core.upload_document(
        %{
          title: %{locale => title},
          category_id: socket.assigns.selected_category,
          file_name: filename,
          mime_type: mime,
          size: byte_size(bytes),
          bytes: bytes
        },
        scope: scope
      )

    {:noreply, load_state(socket, scope, socket.assigns.params)}
  end

  defp load_state(socket, scope, params) do
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

    assign(socket,
      scope: scope,
      params: params,
      locale: locale,
      selected_category: selected_category,
      selected_documents: selected_documents,
      categories: categories,
      documents: documents,
      open_documents: open_documents
    )
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

  defp update_document_param(params, []), do: Map.delete(params, "document")
  defp update_document_param(params, ids), do: Map.put(params, "document", Enum.join(ids, ","))
end
