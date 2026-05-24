defmodule AlexandriaDevWeb.Components.Browser.DocumentList do
  use Phoenix.Component
  import Uikit.Components

  def document_list(assigns) do
    ~H"""
    <table class="uk-table uk-table-divider uk-table-striped uk-table-hover no-select document-list">
      <caption hidden="">Dokumentenliste</caption>
      <thead>
        <tr>
          <th class="uk-text-nowrap document-list-item-type" data-test-sort="type" role="none">
            <span hidden="">Typ</span>
          </th>
          <th
            class="uk-text-nowrap uk-table-expand document-list-item-title cursor-pointer"
            data-test-sort="title"
            role="button"
          >
            Dokumententitel <.uk_icon name="chevron-down" class="uk-margin-small-left" />
          </th>
          <th class="uk-text-nowrap document-list-item-marks" data-test-sort="marks" role="none">
            <span hidden="">Markierungen</span>
          </th>
          <th
            class="uk-text-nowrap document-list-item-date cursor-pointer"
            data-test-sort="date"
            role="button"
          >
            Datum <.uk_icon name="chevron-down" class="uk-margin-small-left" />
          </th>
          <th
            class="uk-text-nowrap document-list-item-modifiedAt cursor-pointer"
            data-test-sort="modifiedAt"
            role="button"
          >
            Änderungsdatum <.uk_icon name="chevron-down" class="uk-margin-small-left" />
          </th>
          <th
            class="uk-text-nowrap document-list-item-createdByUser cursor-pointer"
            data-test-sort="createdByUser"
            role="button"
          >
            Ersteller <.uk_icon name="chevron-down" class="uk-margin-small-left" />
          </th>
          <th
            class="uk-text-nowrap document-list-item-createdByGroup cursor-pointer"
            data-test-sort="createdByGroup"
            role="button"
          >
            Organisation <.uk_icon name="chevron-down" class="uk-margin-small-left" />
          </th>
          <th
            class="uk-text-nowrap document-list-item-category cursor-pointer"
            data-test-sort="category"
            role="button"
          >
            Kategorie <.uk_icon name="chevron-down" class="uk-margin-small-left" />
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
            <.uk_icon name="file-text" data-test-file-icon="" />
          </td>
          <td class="document-list-item-title">
            <span tabindex="0" aria-haspopup="true" aria-expanded="false">
              583-baugesuch.pdf
            </span>
          </td>
          <td class="list-marks uk-flex document-list-item-marks"></td>
          <td class="document-list-item-date"></td>
          <td class="document-list-item-modifiedAt">02.09.2024, 15:21</td>
          <td class="document-list-item-createdByUser">Raphael Kalberer</td>
          <td class="document-list-item-createdByGroup">-</td>
          <td>Weitere Gesuchsunterlagen</td>
        </tr>
      </tbody>
    </table>
    """
  end
end
