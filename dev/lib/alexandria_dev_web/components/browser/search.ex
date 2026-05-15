defmodule AlexandriaDevWeb.Components.Browser.Search do
  use Phoenix.Component
  import Uikit.Components

  def search_bar(assigns) do
    ~H"""
    <form class="uk-background-default uk-search uk-search-default uk-width-1">
      <span uk-search-icon="" class="uk-icon uk-search-icon">
        <svg width="20" height="20" viewBox="0 0 20 20" aria-hidden="true">
          <circle fill="none" stroke="#000" stroke-width="1.1" cx="9" cy="9" r="7"></circle>
          <path fill="none" stroke="#000" stroke-width="1.1" d="M14,14 L18,18 L14,14 Z"></path>
        </svg>
      </span>
      <input
        class="uk-search-input uk-background-default"
        placeholder="Suchen..."
        aria-label="Suchen..."
        data-test-search-input=""
        type="search"
      />
      <a class="uk-form-icon uk-form-icon-flip" href="#" data-test-search-clear="">
        <.uk_icon name="close" />
      </a>
    </form>
    """
  end
end
