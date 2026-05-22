defmodule AlexandriaDevWeb.Components.Browser.Toolbar do
  use Phoenix.Component
  import Uikit.Components

  def toolbar(assigns) do
    ~H"""
    <div class="uk-flex uk-flex-middle uk-padding-small">
      <div class="uk-height-1-1 uk-form-custom" uk-form-custom="" data-test-upload="">
        <.uk_button
          variant="primary"
          size="small"
          class="uk-height-1-1"
          tabindex="-1"
          data-test-upload=""
          aria-haspopup="true"
          aria-expanded="false"
        >
          Datei hochladen
        </.uk_button>

        <div
          uk-drop="mode: click; pos: bottom-left; offset: 5;"
          class="uk-with-medium drop uk-drop"
          data-test-drop=""
        >
          <div class="uk-corner-rounded uk-background-default uk-box-shadow-large uk-flex uk-flex-column uk-overflow-hidden uk-border">
            <a class="item uk-form-custom" href="#" uk-form-custom="" data-test-upload-category="">
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                accept="application/pdf,image/jpeg,image/png,image/gif"
                type="file"
              />
              <.uk_icon name="folder" class="uk-margin-small-right" data-test-folder-icon="" />
              Beilagen zum Gesuch
            </a>
          </div>
        </div>
      </div>

      <div class="uk-border uk-padding-small uk-width-expand uk-flex uk-flex-wrap uk-flex-middle uk-margin-left">
        <span class="uk-margin-small-left">Keine Tags...</span>
      </div>

      <.uk_button
        variant="default"
        size="small"
        class="uk-height-1-1"
        data-test-toggle=""
        data-test-toggle-side-panel=""
      >
        <.uk_icon name="table" data-test-view-toggle-icon="" />
      </.uk_button>
      <.uk_button
        variant="default"
        size="small"
        class="uk-height-1-1"
        data-test-toggle-side-panel=""
      >
        <.uk_icon name="chevron-right" data-test-view-toggle-icon="" />
      </.uk_button>
    </div>
    """
  end
end
