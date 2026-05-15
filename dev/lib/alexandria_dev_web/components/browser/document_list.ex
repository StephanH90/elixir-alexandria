defmodule AlexandriaDevWeb.Components.Browser.DocumentList do
  use Phoenix.Component

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
              583-baugesuch.pdf
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
            02.09.2024, 15:21
          </td>
          <td class="document-list-item-createdByUser">
            Raphael Kalberer
          </td>
          <td class="document-list-itemcreatedByGroup">
            -
          </td>
          <td>Weitere Gesuchsunterlagen</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="3e7d148f-d1d0-4e00-9199-92ba722d7f79"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-image fa-1x"
              data-prefix="fas"
              data-icon="file-image"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 384 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(219, 139, 114);"
            >
              <path
                fill="currentColor"
                d="M64 0C28.7 0 0 28.7 0 64L0 448c0 35.3 28.7 64 64 64l256 0c35.3 0 64-28.7 64-64l0-288-128 0c-17.7 0-32-14.3-32-32L224 0 64 0zM256 0l0 128 128 0L256 0zM64 256a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm152 32c5.3 0 10.2 2.6 13.2 6.9l88 128c3.4 4.9 3.7 11.3 1 16.5s-8.2 8.6-14.2 8.6l-88 0-40 0-48 0-48 0c-5.8 0-11.1-3.1-13.9-8.1s-2.8-11.2 .2-16.1l48-80c2.9-4.8 8.1-7.8 13.7-7.8s10.8 2.9 13.7 7.8l12.8 21.4 48.3-70.2c3-4.3 7.9-6.9 13.2-6.9z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              architectural_example-imperial.dwg
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img alt="architectural_example-imperial.dwg" uk-img="" />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            02.04.2025, 11:25
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Intern</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="a5b3783d-fbe9-4996-a491-3f45312fcabe"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-image fa-1x"
              data-prefix="fas"
              data-icon="file-image"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 384 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(219, 139, 114);"
            >
              <path
                fill="currentColor"
                d="M64 0C28.7 0 0 28.7 0 64L0 448c0 35.3 28.7 64 64 64l256 0c35.3 0 64-28.7 64-64l0-288-128 0c-17.7 0-32-14.3-32-32L224 0 64 0zM256 0l0 128 128 0L256 0zM64 256a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm152 32c5.3 0 10.2 2.6 13.2 6.9l88 128c3.4 4.9 3.7 11.3 1 16.5s-8.2 8.6-14.2 8.6l-88 0-40 0-48 0-48 0c-5.8 0-11.1-3.1-13.9-8.1s-2.8-11.2 .2-16.1l48-80c2.9-4.8 8.1-7.8 13.7-7.8s10.8 2.9 13.7 7.8l12.8 21.4 48.3-70.2c3-4.3 7.9-6.9 13.2-6.9z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              architectural_example-imperial (Kopie) test1123.dwg
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img alt="architectural_example-imperial (Kopie) test1123.dwg" uk-img="" />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            21.10.2025, 10:19
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Intern</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="5a3b519d-80f6-4215-bd71-9bd6da4ad5b8"
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
              Beispielbild.jpg
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img alt="Beispielbild.jpg" uk-img="" />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            02.09.2024, 15:21
          </td>
          <td class="document-list-item-createdByUser">
            Raphael Kalberer
          </td>
          <td class="document-list-itemcreatedByGroup">
            -
          </td>
          <td>Weitere Gesuchsunterlagen</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="fa15a707-fd53-4e7a-81a9-b0b773fd39d2"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-word fa-1x"
              data-prefix="fas"
              data-icon="file-word"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 384 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(219, 139, 114);"
            >
              <path
                fill="currentColor"
                d="M64 0C28.7 0 0 28.7 0 64L0 448c0 35.3 28.7 64 64 64l256 0c35.3 0 64-28.7 64-64l0-288-128 0c-17.7 0-32-14.3-32-32L224 0 64 0zM256 0l0 128 128 0L256 0zM111 257.1l26.8 89.2 31.6-90.3c3.4-9.6 12.5-16.1 22.7-16.1s19.3 6.4 22.7 16.1l31.6 90.3L273 257.1c3.8-12.7 17.2-19.9 29.9-16.1s19.9 17.2 16.1 29.9l-48 160c-3 10-12 16.9-22.4 17.1s-19.8-6.2-23.2-16.1L192 336.6l-33.3 95.3c-3.4 9.8-12.8 16.3-23.2 16.1s-19.5-7.1-22.4-17.1l-48-160c-3.8-12.7 3.4-26.1 16.1-29.9s26.1 3.4 29.9 16.1z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              example.docx
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="example.docx"
                uk-img=""
                loading="lazy"
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/5c004043-1f54-4e84-9b67-0da9f9cc9d25/download?expires=1778654898&amp;signature=CcaypGRxJg3V8xCwdDdKpiJTTLJKXn5L4I4YD_Ypa10"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/5c004043-1f54-4e84-9b67-0da9f9cc9d25/download?expires=1778654898&amp;signature=CcaypGRxJg3V8xCwdDdKpiJTTLJKXn5L4I4YD_Ypa10"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            17.10.2025, 08:56
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Intern</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="25b67b4e-5437-4a0e-94a7-a7f11e9d3385"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-word fa-1x"
              data-prefix="fas"
              data-icon="file-word"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 384 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(219, 139, 114);"
            >
              <path
                fill="currentColor"
                d="M64 0C28.7 0 0 28.7 0 64L0 448c0 35.3 28.7 64 64 64l256 0c35.3 0 64-28.7 64-64l0-288-128 0c-17.7 0-32-14.3-32-32L224 0 64 0zM256 0l0 128 128 0L256 0zM111 257.1l26.8 89.2 31.6-90.3c3.4-9.6 12.5-16.1 22.7-16.1s19.3 6.4 22.7 16.1l31.6 90.3L273 257.1c3.8-12.7 17.2-19.9 29.9-16.1s19.9 17.2 16.1 29.9l-48 160c-3 10-12 16.9-22.4 17.1s-19.8-6.2-23.2-16.1L192 336.6l-33.3 95.3c-3.4 9.8-12.8 16.3-23.2 16.1s-19.5-7.1-22.4-17.1l-48-160c-3.8-12.7 3.4-26.1 16.1-29.9s26.1 3.4 29.9 16.1z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              example.docx
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="example.docx"
                uk-img=""
                loading="lazy"
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/e8ca10ad-d8c7-4fc7-87c5-d1feb5a84d54/download?expires=1778654898&amp;signature=TD2_Nr3CjUgCkTPUhanj9f-m0tNOqRLeXIPv8Ds1VOs"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/e8ca10ad-d8c7-4fc7-87c5-d1feb5a84d54/download?expires=1778654898&amp;signature=TD2_Nr3CjUgCkTPUhanj9f-m0tNOqRLeXIPv8Ds1VOs"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            09.04.2026, 14:25
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Intern</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="e9f26649-a7b9-41dd-aa4d-4c991116dff6"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-word fa-1x"
              data-prefix="fas"
              data-icon="file-word"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 384 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(219, 139, 114);"
            >
              <path
                fill="currentColor"
                d="M64 0C28.7 0 0 28.7 0 64L0 448c0 35.3 28.7 64 64 64l256 0c35.3 0 64-28.7 64-64l0-288-128 0c-17.7 0-32-14.3-32-32L224 0 64 0zM256 0l0 128 128 0L256 0zM111 257.1l26.8 89.2 31.6-90.3c3.4-9.6 12.5-16.1 22.7-16.1s19.3 6.4 22.7 16.1l31.6 90.3L273 257.1c3.8-12.7 17.2-19.9 29.9-16.1s19.9 17.2 16.1 29.9l-48 160c-3 10-12 16.9-22.4 17.1s-19.8-6.2-23.2-16.1L192 336.6l-33.3 95.3c-3.4 9.8-12.8 16.3-23.2 16.1s-19.5-7.1-22.4-17.1l-48-160c-3.8-12.7 3.4-26.1 16.1-29.9s26.1 3.4 29.9 16.1z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              example-template.docx
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="example-template.docx"
                uk-img=""
                loading="lazy"
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/275a37e0-7494-4104-8304-35205e63b335/download?expires=1778654898&amp;signature=6LX0CM7pjjcESSnkf4hjA8dI2DUi8YlcDZn2bU0lEjs"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/275a37e0-7494-4104-8304-35205e63b335/download?expires=1778654898&amp;signature=6LX0CM7pjjcESSnkf4hjA8dI2DUi8YlcDZn2bU0lEjs"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            18.11.2025, 15:43
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Intern</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="505cfddc-247c-438b-890a-edf8b00b9abc"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-pdf fa-1x"
              data-prefix="fas"
              data-icon="file-pdf"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 512 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(219, 139, 114);"
            >
              <path
                fill="currentColor"
                d="M0 64C0 28.7 28.7 0 64 0L224 0l0 128c0 17.7 14.3 32 32 32l128 0 0 144-208 0c-35.3 0-64 28.7-64 64l0 144-48 0c-35.3 0-64-28.7-64-64L0 64zm384 64l-128 0L256 0 384 128zM176 352l32 0c30.9 0 56 25.1 56 56s-25.1 56-56 56l-16 0 0 32c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-48 0-80c0-8.8 7.2-16 16-16zm32 80c13.3 0 24-10.7 24-24s-10.7-24-24-24l-16 0 0 48 16 0zm96-80l32 0c26.5 0 48 21.5 48 48l0 64c0 26.5-21.5 48-48 48l-32 0c-8.8 0-16-7.2-16-16l0-128c0-8.8 7.2-16 16-16zm32 128c8.8 0 16-7.2 16-16l0-64c0-8.8-7.2-16-16-16l-16 0 0 96 16 0zm80-112c0-8.8 7.2-16 16-16l48 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 32 32 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 48c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-64 0-64z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              example-template.pdf
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="example-template.pdf"
                uk-img=""
                loading="lazy"
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/e4a40cb0-0566-4660-b358-f2d2eb20e6cd/download?expires=1778654898&amp;signature=MXV4Y-91DoAxxE1vldSpKCyfOefRujVIuIrotS3pLkw"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/e4a40cb0-0566-4660-b358-f2d2eb20e6cd/download?expires=1778654898&amp;signature=MXV4Y-91DoAxxE1vldSpKCyfOefRujVIuIrotS3pLkw"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            09.04.2026, 14:25
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Intern</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="8ff0079c-69a4-4316-9f51-e2a5bb38f1d2"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-pdf fa-1x"
              data-prefix="fas"
              data-icon="file-pdf"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 512 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(219, 139, 114);"
            >
              <path
                fill="currentColor"
                d="M0 64C0 28.7 28.7 0 64 0L224 0l0 128c0 17.7 14.3 32 32 32l128 0 0 144-208 0c-35.3 0-64 28.7-64 64l0 144-48 0c-35.3 0-64-28.7-64-64L0 64zm384 64l-128 0L256 0 384 128zM176 352l32 0c30.9 0 56 25.1 56 56s-25.1 56-56 56l-16 0 0 32c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-48 0-80c0-8.8 7.2-16 16-16zm32 80c13.3 0 24-10.7 24-24s-10.7-24-24-24l-16 0 0 48 16 0zm96-80l32 0c26.5 0 48 21.5 48 48l0 64c0 26.5-21.5 48-48 48l-32 0c-8.8 0-16-7.2-16-16l0-128c0-8.8 7.2-16 16-16zm32 128c8.8 0 16-7.2 16-16l0-64c0-8.8-7.2-16-16-16l-16 0 0 96 16 0zm80-112c0-8.8 7.2-16 16-16l48 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 32 32 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 48c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-64 0-64z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              example-template.pdf
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="example-template.pdf"
                uk-img=""
                loading="lazy"
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/9a1a318f-7fee-470c-978f-f8f64f7f96ea/download?expires=1778654898&amp;signature=IYySqanV4bIl6JCi2x-9b1ijxOO23jPG-JzN9c7QNOs"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/9a1a318f-7fee-470c-978f-f8f64f7f96ea/download?expires=1778654898&amp;signature=IYySqanV4bIl6JCi2x-9b1ijxOO23jPG-JzN9c7QNOs"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            21.11.2025, 13:42
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Intern</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="4a952b49-3c9e-4a47-8ed3-aa1136273245"
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
              Nachweis_Einverständnis Nachbar.pdf
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img alt="Nachweis_Einverständnis Nachbar.pdf" uk-img="" loading="lazy" />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            02.09.2024, 15:21
          </td>
          <td class="document-list-item-createdByUser">
            Raphael Kalberer
          </td>
          <td class="document-list-itemcreatedByGroup">
            -
          </td>
          <td>Gutachten, Nachweise, Begründungen</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="713d3b69-c7b9-4b5f-9378-faefe9d7a06b"
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
              Projektplan_Beschrieb.pdf
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img alt="Projektplan_Beschrieb.pdf" uk-img="" loading="lazy" />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            02.09.2024, 15:21
          </td>
          <td class="document-list-item-createdByUser">
            Raphael Kalberer
          </td>
          <td class="document-list-itemcreatedByGroup">
            -
          </td>
          <td>Grundstücksangaben, Projektpläne und -beschrieb</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="ee28abd2-e34a-4157-8bc4-543a323ee8ad"
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
              Projektplan_Situationsplan.pdf
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img alt="Projektplan_Situationsplan.pdf" uk-img="" loading="lazy" />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            02.09.2024, 15:21
          </td>
          <td class="document-list-item-createdByUser">
            Raphael Kalberer
          </td>
          <td class="document-list-itemcreatedByGroup">
            -
          </td>
          <td>Grundstücksangaben, Projektpläne und -beschrieb</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="2ada614e-6bc6-4301-8b40-664c0d3bdd33"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-pdf fa-1x"
              data-prefix="fas"
              data-icon="file-pdf"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 512 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(203, 104, 193);"
            >
              <path
                fill="currentColor"
                d="M0 64C0 28.7 28.7 0 64 0L224 0l0 128c0 17.7 14.3 32 32 32l128 0 0 144-208 0c-35.3 0-64 28.7-64 64l0 144-48 0c-35.3 0-64-28.7-64-64L0 64zm384 64l-128 0L256 0 384 128zM176 352l32 0c30.9 0 56 25.1 56 56s-25.1 56-56 56l-16 0 0 32c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-48 0-80c0-8.8 7.2-16 16-16zm32 80c13.3 0 24-10.7 24-24s-10.7-24-24-24l-16 0 0 48 16 0zm96-80l32 0c26.5 0 48 21.5 48 48l0 64c0 26.5-21.5 48-48 48l-32 0c-8.8 0-16-7.2-16-16l0-128c0-8.8 7.2-16 16-16zm32 128c8.8 0 16-7.2 16-16l0-64c0-8.8-7.2-16-16-16l-16 0 0 96 16 0zm80-112c0-8.8 7.2-16 16-16l48 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 32 32 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 48c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-64 0-64z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              sample_copy.pdf
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="sample_copy.pdf"
                uk-img=""
                loading="lazy"
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/ef557ad8-4c88-41a3-b438-9cb4a850f81b/download?expires=1778654898&amp;signature=sivbQSdS4VtP7AVnUQJ1sFtMAiR3mP5yOx_f3_3NuqI"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/ef557ad8-4c88-41a3-b438-9cb4a850f81b/download?expires=1778654898&amp;signature=sivbQSdS4VtP7AVnUQJ1sFtMAiR3mP5yOx_f3_3NuqI"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            28.01.2025, 11:27
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Bauabnahme</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="4e95f531-eb52-4436-92dd-6985bd3287f4"
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
              style="color: rgb(219, 139, 114);"
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
              Sample MSG File.msg
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img alt="Sample MSG File.msg" uk-img="" loading="lazy" />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            02.04.2025, 11:25
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Intern</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="9f5d1e03-da77-4214-afb9-1234b312b8e8"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-pdf fa-1x"
              data-prefix="fas"
              data-icon="file-pdf"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 512 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(219, 139, 114);"
            >
              <path
                fill="currentColor"
                d="M0 64C0 28.7 28.7 0 64 0L224 0l0 128c0 17.7 14.3 32 32 32l128 0 0 144-208 0c-35.3 0-64 28.7-64 64l0 144-48 0c-35.3 0-64-28.7-64-64L0 64zm384 64l-128 0L256 0 384 128zM176 352l32 0c30.9 0 56 25.1 56 56s-25.1 56-56 56l-16 0 0 32c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-48 0-80c0-8.8 7.2-16 16-16zm32 80c13.3 0 24-10.7 24-24s-10.7-24-24-24l-16 0 0 48 16 0zm96-80l32 0c26.5 0 48 21.5 48 48l0 64c0 26.5-21.5 48-48 48l-32 0c-8.8 0-16-7.2-16-16l0-128c0-8.8 7.2-16 16-16zm32 128c8.8 0 16-7.2 16-16l0-64c0-8.8-7.2-16-16-16l-16 0 0 96 16 0zm80-112c0-8.8 7.2-16 16-16l48 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 32 32 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 48c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-64 0-64z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              sample.pdf
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="sample.pdf"
                uk-img=""
                loading="lazy"
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/f76a0dc3-e92c-4e9a-80bf-3b2130a8f830/download?expires=1778654898&amp;signature=KZqsQ12KmW3eb-BMu43T-Ud6KTIy8AO72kqQOwybXGI"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/f76a0dc3-e92c-4e9a-80bf-3b2130a8f830/download?expires=1778654898&amp;signature=KZqsQ12KmW3eb-BMu43T-Ud6KTIy8AO72kqQOwybXGI"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            28.01.2025, 11:23
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Intern</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="3b071ad4-ce36-49d4-8e9b-00a7f4e9ee95"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-pdf fa-1x"
              data-prefix="fas"
              data-icon="file-pdf"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 512 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(203, 104, 193);"
            >
              <path
                fill="currentColor"
                d="M0 64C0 28.7 28.7 0 64 0L224 0l0 128c0 17.7 14.3 32 32 32l128 0 0 144-208 0c-35.3 0-64 28.7-64 64l0 144-48 0c-35.3 0-64-28.7-64-64L0 64zm384 64l-128 0L256 0 384 128zM176 352l32 0c30.9 0 56 25.1 56 56s-25.1 56-56 56l-16 0 0 32c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-48 0-80c0-8.8 7.2-16 16-16zm32 80c13.3 0 24-10.7 24-24s-10.7-24-24-24l-16 0 0 48 16 0zm96-80l32 0c26.5 0 48 21.5 48 48l0 64c0 26.5-21.5 48-48 48l-32 0c-8.8 0-16-7.2-16-16l0-128c0-8.8 7.2-16 16-16zm32 128c8.8 0 16-7.2 16-16l0-64c0-8.8-7.2-16-16-16l-16 0 0 96 16 0zm80-112c0-8.8 7.2-16 16-16l48 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 32 32 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 48c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-64 0-64z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              sample.pdf
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="sample.pdf"
                uk-img=""
                loading="lazy"
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/546e62bb-d01b-43cb-becf-a42a876070de/download?expires=1778654898&amp;signature=X6GOjPFnpNPma_RmdsFuMYTareVe-xE0VJ5FX-vtmSk"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/546e62bb-d01b-43cb-becf-a42a876070de/download?expires=1778654898&amp;signature=X6GOjPFnpNPma_RmdsFuMYTareVe-xE0VJ5FX-vtmSk"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            28.01.2025, 11:25
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Bauabnahme</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="395bcd4e-6b47-4cb1-9811-b3f2aa1e1d1a"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-pdf fa-1x"
              data-prefix="fas"
              data-icon="file-pdf"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 512 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(203, 104, 193);"
            >
              <path
                fill="currentColor"
                d="M0 64C0 28.7 28.7 0 64 0L224 0l0 128c0 17.7 14.3 32 32 32l128 0 0 144-208 0c-35.3 0-64 28.7-64 64l0 144-48 0c-35.3 0-64-28.7-64-64L0 64zm384 64l-128 0L256 0 384 128zM176 352l32 0c30.9 0 56 25.1 56 56s-25.1 56-56 56l-16 0 0 32c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-48 0-80c0-8.8 7.2-16 16-16zm32 80c13.3 0 24-10.7 24-24s-10.7-24-24-24l-16 0 0 48 16 0zm96-80l32 0c26.5 0 48 21.5 48 48l0 64c0 26.5-21.5 48-48 48l-32 0c-8.8 0-16-7.2-16-16l0-128c0-8.8 7.2-16 16-16zm32 128c8.8 0 16-7.2 16-16l0-64c0-8.8-7.2-16-16-16l-16 0 0 96 16 0zm80-112c0-8.8 7.2-16 16-16l48 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 32 32 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 48c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-64 0-64z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              sample.pdf
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="sample.pdf"
                uk-img=""
                loading="lazy"
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/91d6800d-32c0-4bd2-b87b-e4aa161549c7/download?expires=1778654898&amp;signature=rsYnqaKS1T7NZMd8639GflWAIWWZlBYEMzUbAelgETo"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/91d6800d-32c0-4bd2-b87b-e4aa161549c7/download?expires=1778654898&amp;signature=rsYnqaKS1T7NZMd8639GflWAIWWZlBYEMzUbAelgETo"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            28.01.2025, 11:27
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Bauabnahme</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="ac7f63a6-615e-4d03-bb4c-652ebf124f45"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-pdf fa-1x"
              data-prefix="fas"
              data-icon="file-pdf"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 512 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(203, 104, 193);"
            >
              <path
                fill="currentColor"
                d="M0 64C0 28.7 28.7 0 64 0L224 0l0 128c0 17.7 14.3 32 32 32l128 0 0 144-208 0c-35.3 0-64 28.7-64 64l0 144-48 0c-35.3 0-64-28.7-64-64L0 64zm384 64l-128 0L256 0 384 128zM176 352l32 0c30.9 0 56 25.1 56 56s-25.1 56-56 56l-16 0 0 32c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-48 0-80c0-8.8 7.2-16 16-16zm32 80c13.3 0 24-10.7 24-24s-10.7-24-24-24l-16 0 0 48 16 0zm96-80l32 0c26.5 0 48 21.5 48 48l0 64c0 26.5-21.5 48-48 48l-32 0c-8.8 0-16-7.2-16-16l0-128c0-8.8 7.2-16 16-16zm32 128c8.8 0 16-7.2 16-16l0-64c0-8.8-7.2-16-16-16l-16 0 0 96 16 0zm80-112c0-8.8 7.2-16 16-16l48 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 32 32 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 48c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-64 0-64z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              sample.pdf
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="sample.pdf"
                uk-img=""
                loading="lazy"
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/7e3195a0-bc3e-4542-bf62-1441cfdbd9c0/download?expires=1778654898&amp;signature=UxyRTmevkW7uGx2XJH9rNTwXZTUGd-QSAxILzB_2ncw"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/7e3195a0-bc3e-4542-bf62-1441cfdbd9c0/download?expires=1778654898&amp;signature=UxyRTmevkW7uGx2XJH9rNTwXZTUGd-QSAxILzB_2ncw"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            28.01.2025, 11:29
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            Gemeinde Schmitten (GR)
          </td>
          <td>Bauabnahme</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="b8f23ad0-8717-4769-afb3-09bdbc96af4b"
          tabindex="0"
          draggable="true"
        >
          <td class="uk-preserve-width document-list-item-type">
            <svg
              class="svg-inline--fa fa-file-pdf fa-1x"
              data-prefix="fas"
              data-icon="file-pdf"
              aria-hidden="true"
              focusable="false"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 512 512"
              data-test-file-icon=""
              tabindex="0"
              style="color: rgb(203, 104, 193);"
            >
              <path
                fill="currentColor"
                d="M0 64C0 28.7 28.7 0 64 0L224 0l0 128c0 17.7 14.3 32 32 32l128 0 0 144-208 0c-35.3 0-64 28.7-64 64l0 144-48 0c-35.3 0-64-28.7-64-64L0 64zm384 64l-128 0L256 0 384 128zM176 352l32 0c30.9 0 56 25.1 56 56s-25.1 56-56 56l-16 0 0 32c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-48 0-80c0-8.8 7.2-16 16-16zm32 80c13.3 0 24-10.7 24-24s-10.7-24-24-24l-16 0 0 48 16 0zm96-80l32 0c26.5 0 48 21.5 48 48l0 64c0 26.5-21.5 48-48 48l-32 0c-8.8 0-16-7.2-16-16l0-128c0-8.8 7.2-16 16-16zm32 128c8.8 0 16-7.2 16-16l0-64c0-8.8-7.2-16-16-16l-16 0 0 96 16 0zm80-112c0-8.8 7.2-16 16-16l48 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 32 32 0c8.8 0 16 7.2 16 16s-7.2 16-16 16l-32 0 0 48c0 8.8-7.2 16-16 16s-16-7.2-16-16l0-64 0-64z"
              >
              </path>
            </svg>
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              sample.pdf
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="sample.pdf"
                uk-img=""
                loading="lazy"
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/7fbda1b3-a419-4cf8-acf2-66ac238c53b6/download?expires=1778654898&amp;signature=ga5vFjpe4D8llTqoi3qGTd75bSWqvLjkTveIXpVl9X8"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/7fbda1b3-a419-4cf8-acf2-66ac238c53b6/download?expires=1778654898&amp;signature=ga5vFjpe4D8llTqoi3qGTd75bSWqvLjkTveIXpVl9X8"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            20.03.2025, 14:43
          </td>
          <td class="document-list-item-createdByUser">
            Stephan Hug
          </td>
          <td class="document-list-itemcreatedByGroup">
            -
          </td>
          <td>Alle Beteiligten</td>
        </tr>
        <tr
          class="document-list-item"
          data-test-document-list-item=""
          data-test-document-list-item-id="1904f859-421d-4828-9264-4444b833dd0e"
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
              style="color: rgb(102, 207, 201);"
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
              Test PDF Ansichten.pdf
            </span>
            <div
              class="document-thumbnail uk-dropdown uk-drop"
              uk-dropdown="pos: right-center; offset: 15; delay-show: 400; delay-hide: 100; container: .alexandria-container;"
            >
              <img
                alt="Test PDF Ansichten.pdf"
                uk-img=""
                loading="lazy"
                data-src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/d6facfce-685c-477d-b5da-8a1b256e1785/download?expires=1778654898&amp;signature=H_wTFg_20bI_FIoSaXX9yXOg9afM0M38Fx8WjFmo7OY"
                src="https://test.admin.ebau.gr.ch/alexandria/api/v1/files/d6facfce-685c-477d-b5da-8a1b256e1785/download?expires=1778654898&amp;signature=H_wTFg_20bI_FIoSaXX9yXOg9afM0M38Fx8WjFmo7OY"
              />
            </div>
          </td>
          <td class="list-marks uk-flex document-list-item-marks">
            <!---->
          </td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">
            02.09.2024, 15:21
          </td>
          <td class="document-list-item-createdByUser">
            Raphael Kalberer
          </td>
          <td class="document-list-itemcreatedByGroup">
            -
          </td>
          <td>Nachforderung</td>
        </tr>
      </tbody>
    </table>
    """
  end
end
