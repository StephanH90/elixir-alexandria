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
          :for={category <- @categories}
          class="category-nav__category"
          data-test-all-files=""
          phx-click="alexandria:navigate"
          phx-value-category={category.slug}
        >
          <div
            class={["uk-link-reset", category.slug == @active_category.slug && "active"]}
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
                {category.display_name}
              </div>
              <.uk_icon
                name="info"
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-flex-auto uk-text-right category-nav__category__info-icon"
                tabindex="0"
                aria-haspopup="true"
                aria-expanded="false"
              />
              <.uk_dropdown id={category.slug <> "-tooltip"} class="category-nav__category__info-box">
                <div>
                  <p>{category.display_description}</p>
                </div>
              </.uk_dropdown>

              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                {category.active_document_count}
              </div>
            </div>
          </div>
        </li>
      </ul>
    </nav>
    """
  end
end
