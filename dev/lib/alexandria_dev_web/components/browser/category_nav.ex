defmodule AlexandriaDevWeb.Components.Browser.CategoryNav do
  use Phoenix.Component
  import Uikit.Components

  attr :categories, :list, required: true
  attr :active_category, Alexandria.Core.Category, default: nil

  def category_nav(assigns) do
    ~H"""
    <nav class="uk-background-muted uk-border-right side-nav">
      <div class="uk-padding-small uk-width-1 uk-text-bold uk-border-bottom">
        <div class="uk-text-center" data-test-nav-title="">
          <span class="category-header">
            Kategorien
          </span>
        </div>
      </div>
      <ul class="uk-nav uk-width-medium uk-margin-top category-nav">
        <li
          class="category-nav__category"
          data-test-all-files=""
        >
          <div
            class="uk-link-reset active"
            tabindex="0"
            data-test-link=""
          >
            <div class="uk-flex uk-flex-middle">
              <div class="uk-margin-right ">
                <svg
                  class="svg-inline--fa fa-folder-open fa-fw"
                  data-prefix="far"
                  data-icon="folder-open"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 576 512"
                  data-test-icon=""
                  style="color: rgb(227, 227, 227);"
                  tabindex="0"
                >
                  <path
                    fill="currentColor"
                    d="M384 480l48 0c11.4 0 21.9-6 27.6-15.9l112-192c5.8-9.9 5.8-22.1 .1-32.1S555.5 224 544 224l-400 0c-11.4 0-21.9 6-27.6 15.9L48 357.1 48 96c0-8.8 7.2-16 16-16l117.5 0c4.2 0 8.3 1.7 11.3 4.7l26.5 26.5c21 21 49.5 32.8 79.2 32.8L416 144c8.8 0 16 7.2 16 16l0 32 48 0 0-32c0-35.3-28.7-64-64-64L298.5 96c-17 0-33.3-6.7-45.3-18.7L226.7 50.7c-12-12-28.3-18.7-45.3-18.7L64 32C28.7 32 0 60.7 0 96L0 416c0 35.3 28.7 64 64 64l23.7 0L384 480z"
                  >
                  </path>
                </svg>
              </div>
              <div class="uk-text-break uk-overflow-hidden" data-test-name="">
                Display name
              </div>
              <.uk_icon
                name="info"
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-flex-auto uk-text-right category-nav__category__info-icon"
                tabindex="0"
                aria-haspopup="true"
                aria-expanded="false"
              />
              <.uk_dropdown id="tooltip" class="category-nav__category__info-box">
                <div>
                  <p>Description</p>
                </div>
              </.uk_dropdown>

              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                active document count
              </div>
            </div>
          </div>
          <!---->
        </li>
        <li
          class="category-nav__category
    "
          data-test-category=""
        >
          <div class="uk-link-reset " tabindex="0" data-test-link="">
            <div class="uk-flex uk-flex-middle">
              <div class="uk-margin-right ">
                <svg
                  class="svg-inline--fa fa-folder fa-fw"
                  data-prefix="far"
                  data-icon="folder"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 512 512"
                  data-test-icon=""
                  style="color: rgb(156, 221, 105);"
                  tabindex="0"
                >
                  <path
                    fill="currentColor"
                    d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                  >
                  </path>
                </svg>
              </div>
              <div
                class="uk-text-break uk-overflow-hidden"
                data-test-name=""
                data-test-category-id="beilagen-zum-gesuch"
              >
                Beilagen zum Gesuch
              </div>
              <.uk_icon
                name="info"
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-flex-auto uk-text-right category-nav__category__info-icon"
                tabindex="0"
                aria-haspopup="true"
                aria-expanded="false"
              />
              <.uk_dropdown id="info-beilagen-gesuch" class="category-nav__category__info-box">
                <div>
                  <p>
                    Diese Dokumente wurden vom Gesuchstellenden hochgeladen und sind für alle am Verfahren beteiligten Behörden einsehbar.
                  </p>
                </div>
              </.uk_dropdown>

              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                5
              </div>
            </div>
          </div>
          <!---->
        </li>
        <li
          class="category-nav__category
    "
          data-test-category=""
        >
          <div class="uk-link-reset " tabindex="0" data-test-link="">
            <div class="uk-flex uk-flex-middle">
              <div class="uk-margin-right ">
                <svg
                  class="svg-inline--fa fa-folder fa-fw"
                  data-prefix="far"
                  data-icon="folder"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 512 512"
                  data-test-icon=""
                  style="color: rgb(102, 207, 201);"
                  tabindex="0"
                >
                  <path
                    fill="currentColor"
                    d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                  >
                  </path>
                </svg>
              </div>
              <div
                class="uk-text-break uk-overflow-hidden"
                data-test-name=""
                data-test-category-id="nachforderung"
              >
                Nachforderung
              </div>
              <.uk_icon
                name="info"
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-flex-auto uk-text-right category-nav__category__info-icon"
                tabindex="0"
                aria-haspopup="true"
                aria-expanded="false"
              />
              <.uk_dropdown id="info-nachforderung" class="category-nav__category__info-box">
                <div>
                  <p>
                    Diese Dokumente wurden vom Gesuchstellenden und Behörden im Rahmen von Nachforderungen hochgeladen und sind für Gesuchsteller und alle am Verfahren beteiligten Behörden einsehbar.
                  </p>
                </div>
              </.uk_dropdown>

              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                1
              </div>
            </div>
          </div>
          <!---->
        </li>
        <li
          class="category-nav__category
    "
          data-test-category=""
        >
          <div class="uk-link-reset " tabindex="0" data-test-link="">
            <div class="uk-flex uk-flex-middle">
              <div class="uk-margin-right ">
                <svg
                  class="svg-inline--fa fa-folder fa-fw"
                  data-prefix="far"
                  data-icon="folder"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 512 512"
                  data-test-icon=""
                  style="color: rgb(203, 104, 193);"
                  tabindex="0"
                >
                  <path
                    fill="currentColor"
                    d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                  >
                  </path>
                </svg>
              </div>
              <div
                class="uk-text-break uk-overflow-hidden"
                data-test-name=""
                data-test-category-id="alle-beteiligten"
              >
                Alle Beteiligten
              </div>
              <.uk_icon
                name="info"
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-flex-auto uk-text-right category-nav__category__info-icon"
                tabindex="0"
                aria-haspopup="true"
                aria-expanded="false"
              />
              <.uk_dropdown
                id="info-alle-beteiligten"
                class="category-nav__category__info-box"
                style="max-width: 1880px; top: 429.75px; left: 399.017px;"
              >
                <div>
                  <p>
                    Hier werden von der Gemeinde Dokumente hochgeladen, welche für alle am Verfahren beteiligten Rollen einsehbar sein sollen (z.B. Verfahrensprogramm, Bauentscheid). Gesuchstellenden werden diese Dokumente im eBau-Portal unter
                    <em>Rückmeldungen</em>
                    angezeigt.
                  </p>
                </div>
              </.uk_dropdown>

              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                1
              </div>
            </div>
          </div>
          <!---->
        </li>
        <li
          class="category-nav__category
    "
          data-test-category=""
        >
          <div class="uk-link-reset " tabindex="0" data-test-link="">
            <div class="uk-flex uk-flex-middle">
              <div class="uk-margin-right ">
                <svg
                  class="svg-inline--fa fa-folder fa-fw"
                  data-prefix="far"
                  data-icon="folder"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 512 512"
                  data-test-icon=""
                  style="color: rgb(135, 145, 236);"
                  tabindex="0"
                >
                  <path
                    fill="currentColor"
                    d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                  >
                  </path>
                </svg>
              </div>
              <div
                class="uk-text-break uk-overflow-hidden"
                data-test-name=""
                data-test-category-id="beteiligte-behörden"
              >
                Beteiligte Behörden
              </div>
              <.uk_icon
                name="info"
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-flex-auto uk-text-right category-nav__category__info-icon"
                tabindex="0"
                aria-haspopup="true"
                aria-expanded="false"
              />
              <.uk_dropdown id="info-beteiligte-behoerden" class="category-nav__category__info-box">
                <div>
                  <p>
                    Hier werden die von den beteiligten Behörden erfassten Dokumente (z.B. Verfügungen, Amts- und Fachberichte, Stellungnahmen) hochgeladen. Diese Dokumente sind nur für die am Verfahren beteiligten Behörden sichtbar, nicht aber für die Gesuchstellenden.
                  </p>
                </div>
              </.uk_dropdown>

              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                0
              </div>
            </div>
          </div>
          <!---->
        </li>
        <li
          class="category-nav__category
    "
          data-test-category=""
        >
          <div class="uk-link-reset " tabindex="0" data-test-link="">
            <div class="uk-flex uk-flex-middle">
              <div class="uk-margin-right ">
                <svg
                  class="svg-inline--fa fa-folder fa-fw"
                  data-prefix="far"
                  data-icon="folder"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 512 512"
                  data-test-icon=""
                  style="color: rgb(225, 180, 34);"
                  tabindex="0"
                >
                  <path
                    fill="currentColor"
                    d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                  >
                  </path>
                </svg>
              </div>
              <div
                class="uk-text-break uk-overflow-hidden"
                data-test-name=""
                data-test-category-id="einsprachen-beschwerden"
              >
                Einsprachen / Beschwerden
              </div>
              <div class="uk-margin-left uk-flex-auto category-nav__category__info-icon"></div>

              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                0
              </div>
            </div>
          </div>
          <!---->
        </li>
        <li
          class="category-nav__category
    "
          data-test-category=""
        >
          <div class="uk-link-reset " tabindex="0" data-test-link="">
            <div class="uk-flex uk-flex-middle">
              <div class="uk-margin-right ">
                <svg
                  class="svg-inline--fa fa-folder fa-fw"
                  data-prefix="far"
                  data-icon="folder"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 512 512"
                  data-test-icon=""
                  style="color: rgb(203, 104, 193);"
                  tabindex="0"
                >
                  <path
                    fill="currentColor"
                    d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                  >
                  </path>
                </svg>
              </div>
              <div
                class="uk-text-break uk-overflow-hidden"
                data-test-name=""
                data-test-category-id="bauabnahme"
              >
                Bauabnahme
              </div>
              <.uk_icon
                name="info"
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-flex-auto uk-text-right category-nav__category__info-icon"
                tabindex="0"
                aria-haspopup="true"
                aria-expanded="false"
              />
              <.uk_dropdown id="info-bauabnahme" class="category-nav__category__info-box">
                <div>
                  <p>
                    Hier werden von der Gemeinde Dokumente zur Bauabnahme hochgeladen, welche für alle am Verfahren beteiligten Rollen einsehbar sein sollen (z.B. Bauabnahmeprotokoll). Gesuchstellenden werden diese Dokumente im eBau-Portal unter
                    <em>Rückmeldungen</em>
                    angezeigt.
                  </p>
                </div>
              </.uk_dropdown>

              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                4
              </div>
            </div>
          </div>
          <!---->
        </li>
        <li
          class="category-nav__category
    "
          data-test-category=""
        >
          <div class="uk-link-reset " tabindex="0" data-test-link="">
            <div class="uk-flex uk-flex-middle">
              <div class="uk-margin-right ">
                <svg
                  class="svg-inline--fa fa-folder fa-fw"
                  data-prefix="far"
                  data-icon="folder"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 512 512"
                  data-test-icon=""
                  style="color: rgb(219, 139, 114);"
                  tabindex="0"
                >
                  <path
                    fill="currentColor"
                    d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                  >
                  </path>
                </svg>
              </div>
              <div
                class="uk-text-break uk-overflow-hidden"
                data-test-name=""
                data-test-category-id="intern"
              >
                Intern
              </div>
              <.uk_icon
                name="info"
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-flex-auto uk-text-right category-nav__category__info-icon"
                tabindex="0"
                aria-haspopup="true"
                aria-expanded="false"
              />
              <.uk_dropdown id="info-intern" class="category-nav__category__info-box">
                <div>
                  <p>
                    Hier werden Dokumente hochgeladen, welche nur innerhalb der eigenen Organisation (ohne Unterfachstellen) sichtbar sein sollen. In diesem Ordner bestehen keine Einschränkungen hinsichtlich der erlaubten Dateiformate.
                  </p>
                </div>
              </.uk_dropdown>

              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                9
              </div>
            </div>
          </div>
          <!---->
        </li>
        <li
          class="category-nav__category
    "
          data-test-category=""
        >
          <div class="uk-link-reset " tabindex="0" data-test-link="">
            <div class="uk-flex uk-flex-middle">
              <div class="uk-margin-right ">
                <svg
                  class="svg-inline--fa fa-folder fa-fw"
                  data-prefix="far"
                  data-icon="folder"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 512 512"
                  data-test-icon=""
                  style="color: rgb(175, 96, 35);"
                  tabindex="0"
                >
                  <path
                    fill="currentColor"
                    d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                  >
                  </path>
                </svg>
              </div>
              <div
                class="uk-text-break uk-overflow-hidden"
                data-test-name=""
                data-test-category-id="intern-mit-unterfachstellen"
              >
                Intern (mit Unterfachstellen)
              </div>
              <.uk_icon
                name="info"
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-flex-auto uk-text-right category-nav__category__info-icon"
                tabindex="0"
                aria-haspopup="true"
                aria-expanded="false"
              />
              <.uk_dropdown id="info-intern-unterfachstellen" class="category-nav__category__info-box">
                <div>
                  <p>
                    Hier werden Dokumente hochgeladen, welche innerhalb der eigenen Organisation (mit Unterfachstellen) sichtbar sein sollen. In diesem Ordner bestehen keine Einschränkungen hinsichtlich der erlaubten Dateiformate.
                  </p>
                </div>
              </.uk_dropdown>

              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                0
              </div>
            </div>
          </div>
          <!---->
        </li>
        <li
          class="category-nav__category
    "
          data-test-category=""
        >
          <div class="uk-link-reset " tabindex="0" data-test-link="">
            <div class="uk-flex uk-flex-middle">
              <div class="uk-margin-right ">
                <svg
                  class="svg-inline--fa fa-folder fa-fw"
                  data-prefix="far"
                  data-icon="folder"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 512 512"
                  data-test-icon=""
                  style="color: rgb(0, 0, 0);"
                  tabindex="0"
                >
                  <path
                    fill="currentColor"
                    d="M0 96C0 60.7 28.7 32 64 32l132.1 0c19.1 0 37.4 7.6 50.9 21.1L289.9 96 448 96c35.3 0 64 28.7 64 64l0 256c0 35.3-28.7 64-64 64L64 480c-35.3 0-64-28.7-64-64L0 96zM64 80c-8.8 0-16 7.2-16 16l0 320c0 8.8 7.2 16 16 16l384 0c8.8 0 16-7.2 16-16l0-256c0-8.8-7.2-16-16-16l-161.4 0c-10.6 0-20.8-4.2-28.3-11.7L213.1 87c-4.5-4.5-10.6-7-17-7L64 80z"
                  >
                  </path>
                </svg>
              </div>
              <div
                class="uk-text-break uk-overflow-hidden"
                data-test-name=""
                data-test-category-id="migrierte-dokumente"
              >
                Migrierte Dokumente
              </div>
              <div class="uk-margin-left uk-flex-auto category-nav__category__info-icon"></div>

              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                0
              </div>
            </div>
          </div>
          <!---->
        </li>
      </ul>
    </nav>
    """
  end
end
