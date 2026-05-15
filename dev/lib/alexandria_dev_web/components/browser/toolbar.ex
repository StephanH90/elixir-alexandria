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
            <a
              class="item uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                accept="application/pdf,image/jpeg,image/png,image/gif,image/vnd.dwg,.dwg"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(156, 221, 105);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Beilagen zum Gesuch
            </a>
            <a
              class="item item--indent uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(156, 221, 105);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Grundstücksangaben, Projektpläne und -beschrieb
            </a>
            <a
              class="item item--indent uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(156, 221, 105);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Gutachten, Nachweise, Begründungen
            </a>
            <a
              class="item item--indent uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(156, 221, 105);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Brandschutz (Feuerpolizei)
            </a>
            <a
              class="item item--indent uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(156, 221, 105);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Weitere Gesuchsunterlagen
            </a>
            <a
              class="item uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                accept="application/pdf,image/jpeg,image/png,image/gif,image/vnd.dwg,.dwg"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(102, 207, 201);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Nachforderung
            </a>
            <!---->
            <a
              class="item uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                accept="application/pdf,image/jpeg,image/png,image/gif,image/vnd.dwg,.dwg"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(203, 104, 193);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Alle Beteiligten
            </a>
            <!---->
            <a
              class="item uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                accept="application/pdf,image/jpeg,image/png,image/gif,image/vnd.dwg,.dwg"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(135, 145, 236);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Beteiligte Behörden
            </a>
            <!---->
            <a
              class="item uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                accept="application/pdf,image/jpeg,image/png,image/gif"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(225, 180, 34);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Einsprachen / Beschwerden
            </a>
            <a
              class="item item--indent uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(225, 180, 34);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Einsprachen
            </a>
            <a
              class="item item--indent uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(225, 180, 34);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Beschwerden
            </a>
            <a
              class="item uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                accept="application/pdf,image/jpeg,image/png,image/gif,image/vnd.dwg,.dwg"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(203, 104, 193);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Bauabnahme
            </a>
            <!---->
            <a
              class="item uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                accept="application/pdf,image/jpeg,image/png,image/gif,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/vnd.ms-outlook,.msg,image/vnd.dwg,.dwg"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(219, 139, 114);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Intern
            </a>
            <!---->
            <a
              class="item uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                accept="application/pdf,image/jpeg,image/png,image/gif,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/vnd.ms-outlook,.msg,image/vnd.dwg,.dwg"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(175, 96, 35);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Intern (mit Unterfachstellen)
            </a>
            <!---->
            <a
              class="item uk-form-custom"
              href="#"
              uk-form-custom=""
              data-test-upload-category=""
            >
              <input
                multiple="multiple"
                data-test-input=""
                aria-label="file input"
                accept="application/pdf,image/jpeg,image/png,image/gif,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/vnd.ms-outlook,.msg,text/plain"
                type="file"
              />
              <svg
                class="svg-inline--fa fa-folder fa-2x uk-margin-small-right"
                data-prefix="far"
                data-icon="folder"
                aria-hidden="true"
                focusable="false"
                role="img"
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 512 512"
                data-test-folder-icon=""
                style="color: rgb(0, 0, 0);"
              >
                <path
                  fill="currentColor"
                  d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                >
                </path>
              </svg>
              Migrierte Dokumente
            </a>
            <!---->
          </div>
        </div>
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
