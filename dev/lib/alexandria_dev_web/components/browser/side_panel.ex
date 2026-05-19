defmodule AlexandriaDevWeb.Components.Browser.SidePanel do
  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    {:ok,
     assign(socket,
       form: nil,
       form_document_id: nil,
       show_title_input: false,
       show_description_input: false
     )}
  end

  @impl true
  def update(%{selected_documents: [selected_document_id]} = assigns, socket) do
    document = Enum.find(assigns.documents, &(&1.id == selected_document_id))

    socket =
      socket
      |> assign(assigns)
      |> assign(:document, document)
      |> assign_or_reuse_form(selected_document_id, document)
      |> assign_new(:marks, fn -> Alexandria.Core.list_marks!(scope: assigns.scope) end)

    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  defp assign_or_reuse_form(
         %{assigns: %{form_document_id: selected_document_id}} = socket,
         selected_document_id,
         _document
       ) do
    # If we are still editing the same document we re-use the existing form
    socket
  end

  defp assign_or_reuse_form(socket, selected_document_id, document) do
    form =
      Alexandria.Core.form_to_update_document_title_description_date(document,
        scope: socket.assigns.scope
      )
      |> to_form()

    assign(socket, form: form, form_document_id: selected_document_id)
  end

  @impl true
  def handle_event(
        "alexandria:submit-form",
        %{"field" => field, "form" => form_params},
        socket
      ) do
    scope = socket.assigns.scope

    existing_params = AshPhoenix.Form.params(socket.assigns.form)
    merged_params = Map.merge(existing_params, form_params)

    form = AshPhoenix.Form.validate(socket.assigns.form, merged_params)
    field_only_params = Map.take(form_params, [field])

    case AshPhoenix.Form.submit(form, override_params: field_only_params, scope: scope) do
      {:ok, updated_document} ->
        send(self(), {:alexandria_document_updated, updated_document})
        show_flag = String.to_existing_atom("show_#{field}_input")
        {:noreply, socket |> assign(:form, form) |> assign(show_flag, false)}

      {:error, form} ->
        {:noreply, assign(socket, :form, form)}
    end
  end

  @impl true
  def handle_event("alexandria:show-input", %{"field" => field}, socket) do
    field = "show_#{field}_input" |> String.to_existing_atom()
    {:noreply, assign(socket, field, true)}
  end

  @impl true
  def handle_event("alexandria:toggle-mark", %{"mark" => mark}, socket) do
    {:noreply, socket}
  end

  # TODO: UPSTREAM THIS TO ELIXIR_UIKIT
  attr :field, Phoenix.HTML.FormField, required: true
  attr :type, :string, values: ~w(text textarea), default: "text"

  defp uk_multi_lang_input(assigns) do
    value = assigns.field.value["en"]
    name = assigns.field.name <> "[en]"
    assigns = assign(assigns, value: value, name: name, type: assigns.type)
    Uikit.FormComponents.uk_input(assigns)
  end

  attr :icon, :string, required: true
  attr :name, :string, required: true
  attr :document, Alexandria.Core.Document, required: true
  attr :myself, Phoenix.LiveComponent.CID, required: true
  slot :inner_block

  defp mark(assigns) do
    assigns = assign(assigns, :selected?, Enum.member?(assigns.document.tags_slugs, assigns.name))

    ~H"""
    <button
      class={["mark", @selected? && "mark--active"]}
      aria-haspopup="true"
      aria-expanded="false"
      phx-click="alexandria:toggle-mark"
      phx-value-mark={@name}
      phx-target={@myself}
      test-mark-button={@name}
    >
      {@name}
    </button>
    <div
      uk-dropdown=""
      class="uk-padding-small mark__info-box uk-dropdown uk-drop"
      style="top: 114px; left: 1px; max-width: 420px;"
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :selected_documents, :list, default: []
  attr :documents, :list, default: []
  attr :scope, :map, default: %{}
  @impl true
  def render(assigns) do
    ~H"""
    <div
      class="uk-background-muted uk-border-left uk-width-large uk-flex document-details"
      data-test-document-side-panel=""
    >
      <div class="uk-flex uk-flex-between uk-flex-column">
        <div class="uk-overflow-auto">
          <div class="uk-padding-small" data-test-document-side-panel-details="">
            <div class="uk-position-relative" data-test-single-doc-details="">
              <Uikit.FormComponents.uk_form
                :if={@form}
                for={@form}
                id="details-form"
                phx-submit="alexandria:submit-form"
                phx-target={@myself}
              >
                <div class="uk-margin uk-margin-remove-top">
                  <label class="uk-text-meta" for="alexandria-details-title">
                    <button data-test-edit-title="" type="button">
                      Dokumententitel
                      <Uikit.Components.uk_icon
                        name="pencil"
                        phx-click="alexandria:show-input"
                        phx-value-field="title"
                        phx-target={@myself}
                      />
                    </button>
                  </label>
                  <div class="uk-flex uk-flex-middle uk-text-break" data-test-title-container="">
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
                      style="color: rgb(219, 139, 114);"
                    >
                      <path
                        fill="currentColor"
                        d="M64 464c-8.8 0-16-7.2-16-16L48 64c0-8.8 7.2-16 16-16l160 0 0 80c0 17.7 14.3 32 32 32l80 0 0 288c0 8.8-7.2 16-16 16L64 464zM64 0C28.7 0 0 28.7 0 64L0 448c0 35.3 28.7 64 64 64l256 0c35.3 0 64-28.7 64-64l0-293.5c0-17-6.7-33.3-18.7-45.3L274.7 18.7C262.7 6.7 246.5 0 229.5 0L64 0zm56 256c-13.3 0-24 10.7-24 24s10.7 24 24 24l144 0c13.3 0 24-10.7 24-24s-10.7-24-24-24l-144 0zm0 96c-13.3 0-24 10.7-24 24s10.7 24 24 24l144 0c13.3 0 24-10.7 24-24s-10.7-24-24-24l-144 0z"
                      >
                      </path>
                    </svg>
                    <div :if={@show_title_input} class="uk-flex uk-width-expand">
                      <.uk_multi_lang_input field={@form[:title]} />
                      <button
                        type="submit"
                        name="field"
                        value="title"
                        class="uk-icon-button uk-margin-small-left cursor-pointer uk-icon"
                        uk-icon="icon: check"
                        data-test-save=""
                      >
                      </button>
                    </div>
                  </div>
                  <div class="uk-flex uk-flex-middle uk-text-break" data-test-title-container="">
                    <span class="uk-text-bolder" data-test-title="">{@document.display_title}</span>
                  </div>
                  <!---->
                </div>

                <div class="document-marks uk-margin">
                  <.mark name="decision" icon="stamp" myself={@myself} document={@document}>
                    <strong>Entscheiddokument</strong>
                  </.mark>

                  <.mark name="publication" icon="bullhorn" myself={@myself} document={@document}>
                    <strong>Publikationsdokument</strong>
                  </.mark>

                  <label class="mark " tabindex="0" aria-haspopup="true" aria-expanded="false">
                    <svg
                      class="svg-inline--fa fa-bullhorn fa-fw"
                      data-prefix="fas"
                      data-icon="bullhorn"
                      aria-hidden="true"
                      focusable="false"
                      role="img"
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 512 512"
                    >
                      <path
                        fill="currentColor"
                        d="M480 32c0-12.9-7.8-24.6-19.8-29.6s-25.7-2.2-34.9 6.9L381.7 53c-48 48-113.1 75-181 75l-8.7 0-32 0-96 0c-35.3 0-64 28.7-64 64l0 96c0 35.3 28.7 64 64 64l0 128c0 17.7 14.3 32 32 32l64 0c17.7 0 32-14.3 32-32l0-128 8.7 0c67.9 0 133 27 181 75l43.6 43.6c9.2 9.2 22.9 11.9 34.9 6.9s19.8-16.6 19.8-29.6l0-147.6c18.6-8.8 32-32.5 32-60.4s-13.4-51.6-32-60.4L480 32zm-64 76.7L416 240l0 131.3C357.2 317.8 280.5 288 200.7 288l-8.7 0 0-96 8.7 0c79.8 0 156.5-29.8 215.3-83.3z"
                      >
                      </path>
                    </svg>
                    <input hidden="" data-test-add-mark="publication" type="checkbox" />
                  </label>
                  <div
                    uk-dropdown=""
                    class="uk-padding-small mark__info-box uk-dropdown uk-drop"
                    style="top: 114px; left: 41.4501px; max-width: 420px;"
                  >
                    <strong>Publikationsdokument</strong>
                    <div>
                      <!---->
                    </div>
                  </div>
                  <label class="mark " tabindex="0" aria-haspopup="true" aria-expanded="false">
                    <svg
                      class="svg-inline--fa fa-ban fa-fw"
                      data-prefix="fas"
                      data-icon="ban"
                      aria-hidden="true"
                      focusable="false"
                      role="img"
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 512 512"
                    >
                      <path
                        fill="currentColor"
                        d="M367.2 412.5L99.5 144.8C77.1 176.1 64 214.5 64 256c0 106 86 192 192 192c41.5 0 79.9-13.1 111.2-35.5zm45.3-45.3C434.9 335.9 448 297.5 448 256c0-106-86-192-192-192c-41.5 0-79.9 13.1-111.2 35.5L412.5 367.2zM0 256a256 256 0 1 1 512 0A256 256 0 1 1 0 256z"
                      >
                      </path>
                    </svg>
                    <input hidden="" data-test-add-mark="void" type="checkbox" />
                  </label>
                  <div
                    uk-dropdown=""
                    class="uk-padding-small mark__info-box uk-dropdown uk-drop"
                    style="top: 114px; left: 81.9px; max-width: 420px;"
                  >
                    <strong>Ungültig</strong>
                    <div>
                      <!---->
                    </div>
                  </div>
                  <label class="mark " tabindex="0" aria-haspopup="true" aria-expanded="false">
                    <svg
                      class="svg-inline--fa fa-triangle-exclamation fa-fw"
                      data-prefix="fas"
                      data-icon="triangle-exclamation"
                      aria-hidden="true"
                      focusable="false"
                      role="img"
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 512 512"
                    >
                      <path
                        fill="currentColor"
                        d="M256 32c14.2 0 27.3 7.5 34.5 19.8l216 368c7.3 12.4 7.3 27.7 .2 40.1S486.3 480 472 480L40 480c-14.3 0-27.6-7.7-34.7-20.1s-7-27.8 .2-40.1l216-368C228.7 39.5 241.8 32 256 32zm0 128c-13.3 0-24 10.7-24 24l0 112c0 13.3 10.7 24 24 24s24-10.7 24-24l0-112c0-13.3-10.7-24-24-24zm32 224a32 32 0 1 0 -64 0 32 32 0 1 0 64 0z"
                      >
                      </path>
                    </svg>
                    <input hidden="" data-test-add-mark="sensitive" type="checkbox" />
                  </label>
                  <div
                    uk-dropdown=""
                    class="uk-padding-small mark__info-box uk-dropdown uk-drop uk-drop-stack"
                    style="top: 114px; left: -1px; max-width: 420px;"
                  >
                    <strong>Vertraulich</strong>
                    <div>
                      <p>
                        Dieses Dokument enthält persönliche Daten. Das Dokument kann nicht öffentlich publiziert werden.
                      </p>
                    </div>
                  </div>
                </div>

                <div class="uk-margin">
                  <label class="uk-text-meta uk-display-block" for="alexandria-details-description">
                    <button
                      type="button"
                      phx-click="alexandria:show-input"
                      phx-value-field="description"
                      phx-target={@myself}
                    >
                      Dokumentenbeschreibung <span uk-icon="" icon="pencil" class="uk-icon"></span>
                    </button>
                  </label>
                  <div :if={@show_description_input} class="uk-flex">
                    <.uk_multi_lang_input field={@form[:description]} type="textarea" />
                    <button
                      type="submit"
                      name="field"
                      value="description"
                      class="uk-icon-button uk-margin-small-left cursor-pointer uk-icon"
                      uk-icon="icon: check"
                      data-test-save=""
                    >
                    </button>
                  </div>

                  <div class="uk-text-italic">Beschreibung hinzufügen</div>
                </div>

                <div class="uk-margin">
                  <label class="uk-text-meta uk-display-block" for="date">
                    <button data-test-edit-date="" type="button">
                      Dokumentendatum <span uk-icon="" icon="pencil" class="uk-icon"></span>
                    </button>
                  </label>

                  <div class="uk-text-italic">Datum hinzufügen</div>
                </div>
              </Uikit.FormComponents.uk_form>

              <div class="uk-margin">
                <p class="uk-text-meta uk-margin-remove">
                  Metadaten
                </p>
                <ul class="uk-list uk-list-collapse uk-margin-remove">
                  <li data-test-file-type="">
                    <svg
                      class="svg-inline--fa fa-file-word fa-fw uk-margin-small-right"
                      data-prefix="fas"
                      data-icon="file-word"
                      aria-hidden="true"
                      focusable="false"
                      role="img"
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 384 512"
                      tabindex="0"
                    >
                      <path
                        fill="currentColor"
                        d="M64 0C28.7 0 0 28.7 0 64L0 448c0 35.3 28.7 64 64 64l256 0c35.3 0 64-28.7 64-64l0-288-128 0c-17.7 0-32-14.3-32-32L224 0 64 0zM256 0l0 128 128 0L256 0zM111 257.1l26.8 89.2 31.6-90.3c3.4-9.6 12.5-16.1 22.7-16.1s19.3 6.4 22.7 16.1l31.6 90.3L273 257.1c3.8-12.7 17.2-19.9 29.9-16.1s19.9 17.2 16.1 29.9l-48 160c-3 10-12 16.9-22.4 17.1s-19.8-6.2-23.2-16.1L192 336.6l-33.3 95.3c-3.4 9.8-12.8 16.3-23.2 16.1s-19.5-7.1-22.4-17.1l-48-160c-3.8-12.7 3.4-26.1 16.1-29.9s26.1 3.4 29.9 16.1z"
                      >
                      </path>
                    </svg>
                    Word
                  </li>
                  <li data-test-created-at="">
                    <svg
                      class="svg-inline--fa fa-clock fa-fw uk-margin-small-right"
                      data-prefix="fas"
                      data-icon="clock"
                      aria-hidden="true"
                      focusable="false"
                      role="img"
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 512 512"
                      tabindex="0"
                    >
                      <path
                        fill="currentColor"
                        d="M256 0a256 256 0 1 1 0 512A256 256 0 1 1 256 0zM232 120l0 136c0 8 4 15.5 10.7 20l96 64c11 7.4 25.9 4.4 33.3-6.7s4.4-25.9-6.7-33.3L280 243.2 280 120c0-13.3-10.7-24-24-24s-24 10.7-24 24z"
                      >
                      </path>
                    </svg>
                    29.04.2025, 11:04
                  </li>
                  <li data-test-created-by-user="">
                    <svg
                      class="svg-inline--fa fa-user fa-fw uk-margin-small-right"
                      data-prefix="fas"
                      data-icon="user"
                      aria-hidden="true"
                      focusable="false"
                      role="img"
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 448 512"
                      tabindex="0"
                    >
                      <path
                        fill="currentColor"
                        d="M224 256A128 128 0 1 0 224 0a128 128 0 1 0 0 256zm-45.7 48C79.8 304 0 383.8 0 482.3C0 498.7 13.3 512 29.7 512l388.6 0c16.4 0 29.7-13.3 29.7-29.7C448 383.8 368.2 304 269.7 304l-91.4 0z"
                      >
                      </path>
                    </svg>
                    Christian Zosel
                  </li>
                  <li data-test-created-by-group="">
                    <svg
                      class="svg-inline--fa fa-users fa-fw uk-margin-small-right"
                      data-prefix="fas"
                      data-icon="users"
                      aria-hidden="true"
                      focusable="false"
                      role="img"
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 640 512"
                      tabindex="0"
                    >
                      <path
                        fill="currentColor"
                        d="M144 0a80 80 0 1 1 0 160A80 80 0 1 1 144 0zM512 0a80 80 0 1 1 0 160A80 80 0 1 1 512 0zM0 298.7C0 239.8 47.8 192 106.7 192l42.7 0c15.9 0 31 3.5 44.6 9.7c-1.3 7.2-1.9 14.7-1.9 22.3c0 38.2 16.8 72.5 43.3 96c-.2 0-.4 0-.7 0L21.3 320C9.6 320 0 310.4 0 298.7zM405.3 320c-.2 0-.4 0-.7 0c26.6-23.5 43.3-57.8 43.3-96c0-7.6-.7-15-1.9-22.3c13.6-6.3 28.7-9.7 44.6-9.7l42.7 0C592.2 192 640 239.8 640 298.7c0 11.8-9.6 21.3-21.3 21.3l-213.3 0zM224 224a96 96 0 1 1 192 0 96 96 0 1 1 -192 0zM128 485.3C128 411.7 187.7 352 261.3 352l117.3 0C452.3 352 512 411.7 512 485.3c0 14.7-11.9 26.7-26.7 26.7l-330.7 0c-14.7 0-26.7-11.9-26.7-26.7z"
                      >
                      </path>
                    </svg>
                    Gemeinde Aarburg
                  </li>
                </ul>
              </div>

              <div class="uk-grid uk-grid-small uk-child-width-1-2" uk-grid="">
                <div class="uk-first-column">
                  <button
                    class="uk-button uk-button-default uk-button-small uk-width-1"
                    data-test-web-dav-button=""
                    type="button"
                  >
                    Bearbeiten
                  </button>
                </div>

                <div>
                  <button
                    class="uk-button uk-button-default uk-button-small uk-width-1"
                    data-test-convert-button=""
                    type="button"
                  >
                    Zu PDF
                  </button>
                </div>

                <div class="uk-first-column uk-grid-margin">
                  <button
                    class="uk-button uk-button-default uk-button-small uk-width-1"
                    data-test-copy=""
                    type="button"
                  >
                    Kopieren
                  </button>
                </div>

                <div uk-form-custom="" class="uk-form-custom uk-grid-margin">
                  <input
                    data-test-replace=""
                    aria-label="File input"
                    accept="application/pdf,image/jpeg,image/png,image/gif,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.presentationml.presentation,application/vnd.ms-outlook,.msg,image/vnd.dwg,.dwg"
                    type="file"
                  />

                  <button
                    class="uk-width-1 uk-button uk-button-default uk-button-small"
                    tabindex="-1"
                    type="button"
                  >
                    Ersetzen
                  </button>
                </div>

                <div class="uk-width-1-1 uk-grid-margin uk-first-column">
                  <button
                    class="uk-button uk-button-danger uk-button-small uk-width-1"
                    data-test-delete=""
                    type="button"
                  >
                    Löschen
                  </button>
                  
    <!---->
                </div>
              </div>

              <hr />

              <ul uk-accordion="multiple: true" class="uk-accordion">
                <li class="uk-open">
                  <a
                    class="uk-accordion-title"
                    href="#"
                    id="uk-accordion-1"
                    role="button"
                    aria-controls="uk-accordion-2"
                    aria-expanded="true"
                    aria-disabled="false"
                  >
                    Versionsgeschichte
                  </a>
                  <div
                    class="uk-accordion-content"
                    id="uk-accordion-2"
                    role="region"
                    aria-labelledby="uk-accordion-1"
                  >
                    <ul class="uk-list uk-list-divider version-history">
                      <li data-test-file="" class="uk-flex">
                        <span class="uk-width-expand">
                          <span class="uk-margin-right">
                            29.04.2025, 11:04
                          </span>
                          <br />
                          <span class="uk-width-expand">Christian Zosel</span>
                        </span>
                        <span class="uk-flex uk-flex-middle">
                          <span
                            uk-icon=""
                            icon="info"
                            class="uk-icon-link uk-icon"
                            tabindex="0"
                            aria-haspopup="true"
                            aria-expanded="false"
                          >
                            <svg width="20" height="20" viewBox="0 0 20 20" aria-hidden="true">
                              <path d="M12.13,11.59 C11.97,12.84 10.35,14.12 9.1,14.16 C6.17,14.2 9.89,9.46 8.74,8.37 C9.3,8.16 10.62,7.83 10.62,8.81 C10.62,9.63 10.12,10.55 9.88,11.32 C8.66,15.16 12.13,11.15 12.14,11.18 C12.16,11.21 12.16,11.35 12.13,11.59 C12.08,11.95 12.16,11.35 12.13,11.59 L12.13,11.59 Z M11.56,5.67 C11.56,6.67 9.36,7.15 9.36,6.03 C9.36,5 11.56,4.54 11.56,5.67 L11.56,5.67 Z">
                              </path>
                              <circle
                                fill="none"
                                stroke="#000"
                                stroke-width="1.1"
                                cx="10"
                                cy="10"
                                r="9"
                              >
                              </circle>
                            </svg>
                          </span>
                          <div uk-dropdown="" pos="left-bottom" class="uk-dropdown uk-drop">
                            <p>
                              <span class="uk-text-bold">Dateiname</span>
                              <br />
                              <span class="uk-text-break">test.docx</span>
                            </p>
                            <p>
                              <span class="uk-text-bold">Eindeutiger Indentifikationsindex</span>
                              <br />
                              <span class="uk-text-break">
                                sha256:1d70569ee0c57bb9fc131e2663855fcd57029d8948524c0b8767c7b11ad9c248
                              </span>
                            </p>
                          </div>
                          <button
                            class="uk-button uk-button-link uk-flex uk-flex-middle uk-margin-small-left"
                            data-test-file-download-link=""
                            type="button"
                          >
                            <span uk-icon="" icon="download" class="uk-icon">
                              <svg width="20" height="20" viewBox="0 0 20 20" aria-hidden="true">
                                <line fill="none" stroke="#000" x1="10" y1="2.09" x2="10" y2="14.09">
                                </line>
                                <polyline
                                  fill="none"
                                  stroke="#000"
                                  points="6.16 10.62 10 14.46 13.84 10.62"
                                >
                                </polyline>
                                <line stroke="#000" x1="3.5" y1="17.5" x2="16.5" y2="17.5"></line>
                              </svg>
                            </span>
                            <span hidden="">Download</span>
                          </button>
                        </span>
                      </li>
                    </ul>
                  </div>
                </li>
              </ul>

              <ul uk-accordion="multiple: true" class="uk-accordion">
                <li class="uk-open">
                  <a
                    class="uk-accordion-title"
                    href="#"
                    id="uk-accordion-3"
                    role="button"
                    aria-controls="uk-accordion-4"
                    aria-expanded="true"
                    aria-disabled="false"
                  >
                    Tags
                  </a>

                  <div
                    class="uk-accordion-content"
                    id="uk-accordion-4"
                    role="region"
                    aria-labelledby="uk-accordion-3"
                  >
                    <!---->
                    <form class="uk-flex">
                      <input
                        class="uk-input uk-form-small uk-width-1-2 uk-margin-small-right"
                        autocomplete="off"
                        name="tag"
                        aria-label="Tag value"
                        data-test-tag-input=""
                        type="text"
                      />
                      <button
                        class="uk-button uk-button-primary uk-button-small uk-width-1-2"
                        data-test-tag-add=""
                        type="submit"
                      >
                        Hinzufügen
                      </button>
                    </form>

                    <div class="uk-margin-small-top">
                      <!---->
                    </div>
                  </div>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <button
          class="uk-button uk-button-primary uk-button-large uk-width-1-1"
          data-test-download-button=""
          type="button"
        >
          Herunterladen
        </button>
      </div>
    </div>
    """
  end
end
