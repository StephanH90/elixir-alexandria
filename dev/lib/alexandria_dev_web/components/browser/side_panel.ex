defmodule AlexandriaDevWeb.Components.Browser.SidePanel do
  use Phoenix.Component

  def side_panel(assigns) do
    ~H"""
    <div
      class="uk-background-muted uk-border-left uk-width-large uk-flex document-details
    closed"
      data-test-document-side-panel=""
    >
      <div class="uk-flex uk-flex-between uk-flex-column">
        <div class="uk-overflow-auto">
          <div class="uk-padding-small" data-test-document-side-panel-details="">
            <div class="uk-position-relative" data-test-multi-doc-details="">
              <div
                class="uk-margin uk-margin-remove-top uk-flex uk-flex-middle uk-text-large uk-text-break"
                data-test-title-container=""
              >
                <svg
                  class="svg-inline--fa fa-file-lines uk-margin-small-right"
                  data-prefix="far"
                  data-icon="file-lines"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 384 512"
                  data-test-title-icon=""
                >
                  <path
                    fill="currentColor"
                    d="M64 464c-8.8 0-16-7.2-16-16L48 64c0-8.8 7.2-16 16-16l160 0 0 80c0 17.7 14.3 32 32 32l80 0 0 288c0 8.8-7.2 16-16 16L64 464zM64 0C28.7 0 0 28.7 0 64L0 448c0 35.3 28.7 64 64 64l256 0c35.3 0 64-28.7 64-64l0-293.5c0-17-6.7-33.3-18.7-45.3L274.7 18.7C262.7 6.7 246.5 0 229.5 0L64 0zm56 256c-13.3 0-24 10.7-24 24s10.7 24 24 24l144 0c13.3 0 24-10.7 24-24s-10.7-24-24-24l-144 0zm0 96c-13.3 0-24 10.7-24 24s10.7 24 24 24l144 0c13.3 0 24-10.7 24-24s-10.7-24-24-24l-144 0z"
                  >
                  </path>
                </svg>
                Kein Dokument ausgewählt
              </div>
              
    <!---->
            </div>
          </div>
        </div>
        <!---->
      </div>
    </div>
    """
  end
end
