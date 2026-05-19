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
      </div>

      <div class="uk-border uk-padding-small uk-width-expand uk-flex uk-flex-wrap uk-flex-middle uk-margin-left">
        <!---->
        <span class="uk-margin-small-left">Keine Tags...</span>
      </div>

      <.uk_button
        variant="default"
        size="small"
        class="uk-height-1-1"
        data-test-toggle=""
        data-test-toggle-side-panel=""
      >
        <svg
          class="svg-inline--fa fa-table-cells fa-1x view-toggle-icon uk-animation-slide-left-small"
          data-prefix="fas"
          data-icon="table-cells"
          aria-hidden="true"
          focusable="false"
          role="img"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 512 512"
          data-test-view-toggle-icon=""
        >
          <path
            fill="currentColor"
            d="M64 32C28.7 32 0 60.7 0 96L0 416c0 35.3 28.7 64 64 64l384 0c35.3 0 64-28.7 64-64l0-320c0-35.3-28.7-64-64-64L64 32zm88 64l0 64-88 0 0-64 88 0zm56 0l88 0 0 64-88 0 0-64zm240 0l0 64-88 0 0-64 88 0zM64 224l88 0 0 64-88 0 0-64zm232 0l0 64-88 0 0-64 88 0zm64 0l88 0 0 64-88 0 0-64zM152 352l0 64-88 0 0-64 88 0zm56 0l88 0 0 64-88 0 0-64zm240 0l0 64-88 0 0-64 88 0z"
          >
          </path>
        </svg>
      </.uk_button>
      <.uk_button
        variant="default"
        size="small"
        class="uk-height-1-1"
        data-test-toggle-side-panel=""
      >
        <svg
          class="svg-inline--fa fa-chevron-right view-toggle-icon uk-animation-slide-left-small"
          data-prefix="fas"
          data-icon="chevron-right"
          aria-hidden="true"
          focusable="false"
          role="img"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 320 512"
          data-test-view-toggle-icon=""
        >
          <path
            fill="currentColor"
            d="M310.6 233.4c12.5 12.5 12.5 32.8 0 45.3l-192 192c-12.5 12.5-32.8 12.5-45.3 0s-12.5-32.8 0-45.3L242.7 256 73.4 86.6c-12.5-12.5-12.5-32.8 0-45.3s32.8-12.5 45.3 0l192 192z"
          >
          </path>
        </svg>
      </.uk_button>
    </div>
    """
  end
end
