defmodule AlexandriaDevWeb.Components.Browser.DocumentList do
  use Phoenix.Component

  attr :documents, :list, default: []
  attr :current_sort, :string, required: true
  attr :selected_documents, :list, default: []

  def document_list(assigns) do
    ~H"""
    <table class="uk-table uk-table-divider uk-table-striped uk-table-hover no-select document-list">
      <caption hidden="">Dokumentenliste</caption>
      <thead>
        <tr>
          <th
            class="uk-text-nowrap document-list-item-type"
            data-test-sort="type"
            role="none"
          >
            <span hidden="">
              Typ
            </span>
          </th>
          <.sortable_header label="Dokumententitel" attr="title" current_sort={@current_sort} />
          <.sortable_header label="Markierungen" attr="marks" current_sort={@current_sort} />
          <.sortable_header label="Datum" attr="created_at" current_sort={@current_sort} />
          <.sortable_header label="Änderungsdatum" attr="modified_at" current_sort={@current_sort} />
          <.sortable_header label="Ersteller" attr="created_by_user" current_sort={@current_sort} />
          <.sortable_header label="Organisation" attr="created_by_group" current_sort={@current_sort} />
          <.sortable_header
            label="Kategorie"
            attr="category.display_name"
            current_sort={@current_sort}
          />
        </tr>
      </thead>

      <tbody>
        <tr
          :for={document <- @documents}
          class={[
            "document-list-item",
            Enum.member?(@selected_documents, document.id) && "document-list-item--selected"
          ]}
          data-test-document-list-item=""
          data-test-document-list-item-id="e538654f-eaeb-4564-81c9-b561efc08913"
          tabindex="0"
          draggable="true"
          phx-click="alexandria:document-selected"
          phx-value-id={document.id}
          id={"document-row-#{document.id}"}
          role="button"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file fa-1x"
              data-prefix="fas"
              data-icon="file"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 384 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(156, 221, 105);"
            >
              <path
                fill="currentColor"
                d="M0 64C0 28.7 28.7 0 64 0L224 0l0 128c0 17.7 14.3 32 32 32l128 0 0 288c0 35.3-28.7 64-64 64L64 512c-35.3 0-64-28.7-64-64L0 64zm384 64l-128 0L256 0 384 128z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              {document.display_title}
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="583-baugesuch.pdf"
                uk-img=""
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/6223fcd6-3883-41f8-88d0-17de1c905402/download?expires=1778654898&amp;signature=FlIpXDv-6pn5_CeOhW1VeSrCRnAinFxktgXoQqDNH0c"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/6223fcd6-3883-41f8-88d0-17de1c905402/download?expires=1778654898&amp;signature=FlIpXDv-6pn5_CeOhW1VeSrCRnAinFxktgXoQqDNH0c"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date">
            TODO: inject i18n <time datetime={document.created_at}>{document.created_at}</time>
          </td>
          <td class="document-list-item-modifiedAt">
            TODO: inject i18n <time datetime={document.modified_at}>{document.modified_at}</time>
          </td>
          <td class="document-list-item-createdByUser">
            TODO: inject resolver {document.created_by_username}
          </td>
          <td class="document-list-itemcreatedByGroup">
            TODO: inject resolver {document.created_by_user}
          </td>
          <td>{document.category.display_name}</td>
        </tr>
      </tbody>
    </table>
    """
  end

  attr :type, :string, required: true
  attr :current_sort, :string, required: true

  defp sort_icon(assigns) do
    icon =
      cond do
        assigns.current_sort == assigns.type -> "arrow-up"
        assigns.current_sort == "-#{assigns.type}" -> "arrow-down"
        true -> "arrow-down-arrow-up"
      end

    assigns = assign(assigns, :icon, icon)

    ~H"""
    <Uikit.Components.uk_icon name={@icon} class="uk-margin-small-left" />
    """
  end

  attr :attr, :string, required: true
  attr :current_sort, :string, required: true
  attr :label, :string, required: true

  defp sortable_header(assigns) do
    ~H"""
    <th
      class={"uk-text-nowrap uk-table-expand document-list-item-#{@attr} cursor-pointer"}
      data-test-sort={@attr}
      role="button"
      phx-click="alexandria:update-sort"
      phx-value-sort={(@current_sort == @attr && "-#{@attr}") || @attr}
    >
      {@label}
      <.sort_icon current_sort={@current_sort} type={@attr} />
    </th>
    """
  end
end
