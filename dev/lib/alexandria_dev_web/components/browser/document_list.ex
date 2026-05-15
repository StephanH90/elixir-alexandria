defmodule AlexandriaDevWeb.Components.Browser.DocumentList do
  use Phoenix.Component

  attr :documents, :list, default: []
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
          <th
            class="uk-text-nowrap uk-table-expand document-list-item-title cursor-pointer"
            data-test-sort="title"
            role="button"
          >
            Dokumententitel
            <svg
              class="svg-inline--fa fa-sort fa-1x uk-margin-small-left"
              data-prefix="fas"
              data-icon="sort"
              aria-hidden="true"
              focusable="false"
              role="presentation"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 320 512"
            >
              <path
                fill="currentColor"
                d="M137.4 41.4c12.5-12.5 32.8-12.5 45.3 0l128 128c9.2 9.2 11.9 22.9 6.9 34.9s-16.6 19.8-29.6 19.8L32 224c-12.9 0-24.6-7.8-29.6-19.8s-2.2-25.7 6.9-34.9l128-128zm0 429.3l-128-128c-9.2-9.2-11.9-22.9-6.9-34.9s16.6-19.8 29.6-19.8l256 0c12.9 0 24.6 7.8 29.6 19.8s2.2 25.7-6.9 34.9l-128 128c-12.5 12.5-32.8 12.5-45.3 0z"
              >
              </path>
            </svg>
          </th>
          <th
            class="uk-text-nowrap document-list-item-marks"
            data-test-sort="marks"
            role="none"
          >
            <span hidden="">
              Markierungen
            </span>
          </th>
          <th
            class="uk-text-nowrap document-list-item-date cursor-pointer"
            data-test-sort="date"
            role="button"
          >
            Datum
            <svg
              class="svg-inline--fa fa-sort fa-1x uk-margin-small-left"
              data-prefix="fas"
              data-icon="sort"
              aria-hidden="true"
              focusable="false"
              role="presentation"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 320 512"
            >
              <path
                fill="currentColor"
                d="M137.4 41.4c12.5-12.5 32.8-12.5 45.3 0l128 128c9.2 9.2 11.9 22.9 6.9 34.9s-16.6 19.8-29.6 19.8L32 224c-12.9 0-24.6-7.8-29.6-19.8s-2.2-25.7 6.9-34.9l128-128zm0 429.3l-128-128c-9.2-9.2-11.9-22.9-6.9-34.9s16.6-19.8 29.6-19.8l256 0c12.9 0 24.6 7.8 29.6 19.8s2.2 25.7-6.9 34.9l-128 128c-12.5 12.5-32.8 12.5-45.3 0z"
              >
              </path>
            </svg>
          </th>
          <th
            class="uk-text-nowrap document-list-item-modifiedAt cursor-pointer"
            data-test-sort="modifiedAt"
            role="button"
          >
            Änderungsdatum
            <svg
              class="svg-inline--fa fa-sort fa-1x uk-margin-small-left"
              data-prefix="fas"
              data-icon="sort"
              aria-hidden="true"
              focusable="false"
              role="presentation"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 320 512"
            >
              <path
                fill="currentColor"
                d="M137.4 41.4c12.5-12.5 32.8-12.5 45.3 0l128 128c9.2 9.2 11.9 22.9 6.9 34.9s-16.6 19.8-29.6 19.8L32 224c-12.9 0-24.6-7.8-29.6-19.8s-2.2-25.7 6.9-34.9l128-128zm0 429.3l-128-128c-9.2-9.2-11.9-22.9-6.9-34.9s16.6-19.8 29.6-19.8l256 0c12.9 0 24.6 7.8 29.6 19.8s2.2 25.7-6.9 34.9l-128 128c-12.5 12.5-32.8 12.5-45.3 0z"
              >
              </path>
            </svg>
          </th>
          <th
            class="uk-text-nowrap document-list-item-createdByUser cursor-pointer"
            data-test-sort="createdByUser"
            role="button"
          >
            Ersteller
            <svg
              class="svg-inline--fa fa-sort fa-1x uk-margin-small-left"
              data-prefix="fas"
              data-icon="sort"
              aria-hidden="true"
              focusable="false"
              role="presentation"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 320 512"
            >
              <path
                fill="currentColor"
                d="M137.4 41.4c12.5-12.5 32.8-12.5 45.3 0l128 128c9.2 9.2 11.9 22.9 6.9 34.9s-16.6 19.8-29.6 19.8L32 224c-12.9 0-24.6-7.8-29.6-19.8s-2.2-25.7 6.9-34.9l128-128zm0 429.3l-128-128c-9.2-9.2-11.9-22.9-6.9-34.9s16.6-19.8 29.6-19.8l256 0c12.9 0 24.6 7.8 29.6 19.8s2.2 25.7-6.9 34.9l-128 128c-12.5 12.5-32.8 12.5-45.3 0z"
              >
              </path>
            </svg>
          </th>
          <th
            class="uk-text-nowrap document-list-item-createdByGroup cursor-pointer"
            data-test-sort="createdByGroup"
            role="button"
          >
            Organisation
            <svg
              class="svg-inline--fa fa-sort fa-1x uk-margin-small-left"
              data-prefix="fas"
              data-icon="sort"
              aria-hidden="true"
              focusable="false"
              role="presentation"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 320 512"
            >
              <path
                fill="currentColor"
                d="M137.4 41.4c12.5-12.5 32.8-12.5 45.3 0l128 128c9.2 9.2 11.9 22.9 6.9 34.9s-16.6 19.8-29.6 19.8L32 224c-12.9 0-24.6-7.8-29.6-19.8s-2.2-25.7 6.9-34.9l128-128zm0 429.3l-128-128c-9.2-9.2-11.9-22.9-6.9-34.9s16.6-19.8 29.6-19.8l256 0c12.9 0 24.6 7.8 29.6 19.8s2.2 25.7-6.9 34.9l-128 128c-12.5 12.5-32.8 12.5-45.3 0z"
              >
              </path>
            </svg>
          </th>
          <th
            class="uk-text-nowrap document-list-item-category cursor-pointer"
            data-test-sort="category"
            role="button"
          >
            Kategorie
            <svg
              class="svg-inline--fa fa-sort fa-1x uk-margin-small-left"
              data-prefix="fas"
              data-icon="sort"
              aria-hidden="true"
              focusable="false"
              role="presentation"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 320 512"
            >
              <path
                fill="currentColor"
                d="M137.4 41.4c12.5-12.5 32.8-12.5 45.3 0l128 128c9.2 9.2 11.9 22.9 6.9 34.9s-16.6 19.8-29.6 19.8L32 224c-12.9 0-24.6-7.8-29.6-19.8s-2.2-25.7 6.9-34.9l128-128zm0 429.3l-128-128c-9.2-9.2-11.9-22.9-6.9-34.9s16.6-19.8 29.6-19.8l256 0c12.9 0 24.6 7.8 29.6 19.8s2.2 25.7-6.9 34.9l-128 128c-12.5 12.5-32.8 12.5-45.3 0z"
              >
              </path>
            </svg>
          </th>
        </tr>
      </thead>

      <tbody>
        <tr
          :for={document <- @documents}
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="e538654f-eaeb-4564-81c9-b561efc08913"
          tabindex="0"
          draggable="true"
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
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            TODO: inject i18n
            <time datetime={document.modified_at}>{document.modified_at}</time>
          </td>
          <td class="document-list-item-createdByUser">
            TODO: inject resolver
            {document.created_by_user}
          </td>
          <td class="document-list-itemcreatedByGroup">
            TODO: inject resolver
            {document.created_by_user}
          </td>
          <td>{document.category.display_name}</td>
        </tr>
      </tbody>
    </table>
    """
  end
end
