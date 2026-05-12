defmodule Alexandria.Core.Document.Changes.CreateInitialFile do
  @moduledoc false
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, context) do
    actor = context.actor

    Ash.Changeset.after_action(changeset, fn changeset, document ->
      {:ok, _file} =
        Alexandria.Core.upload_original_file(
          %{
            name: Ash.Changeset.get_argument(changeset, :file_name),
            mime_type: Ash.Changeset.get_argument(changeset, :mime_type),
            size: Ash.Changeset.get_argument(changeset, :size),
            document_id: document.id,
            bytes: Ash.Changeset.get_argument(changeset, :bytes)
          },
          actor: actor
        )

      {:ok, document}
    end)
  end
end
