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
          <span class="category-header">Kategorien</span>
        </div>
      </div>
      <ul class="uk-nav uk-width-medium uk-margin-top category-nav">
        <li class="category-nav__category" data-test-all-files="">
          <div class="uk-link-reset active" tabindex="0" data-test-link="">
            <div class="uk-flex uk-flex-middle">
              <div class="uk-margin-right">
                <.uk_icon name="folder" data-test-icon="" />
              </div>
              <div class="uk-text-break uk-overflow-hidden" data-test-name="">
                Alle Dokumente
              </div>
              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                0
              </div>
            </div>
          </div>
        </li>

        <li class="category-nav__category" data-test-category="">
          <div class="uk-link-reset" tabindex="0" data-test-link="">
            <div class="uk-flex uk-flex-middle">
              <div class="uk-margin-right">
                <.uk_icon name="folder" data-test-icon="" />
              </div>
              <div
                class="uk-text-break uk-overflow-hidden"
                data-test-name=""
                data-test-category-id="beilagen-zum-gesuch"
              >
                Beilagen zum Gesuch
              </div>
              <div
                class="uk-margin-auto-left uk-margin-right uk-text-muted uk-text-right"
                data-test-document-count=""
              >
                5
              </div>
            </div>
          </div>
        </li>
      </ul>
    </nav>
    """
  end
end
