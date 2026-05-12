defmodule Alexandria.Core.Document.Changes.CreateInitialFile do
  @moduledoc false
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, context) do
    actor = context.actor

    Ash.Changeset.after_action(changeset, fn changeset, document ->
      params = %{
        name: Ash.Changeset.get_argument(changeset, :file_name),
        mime_type: Ash.Changeset.get_argument(changeset, :mime_type),
        size: Ash.Changeset.get_argument(changeset, :size),
        document_id: document.id,
        bytes: Ash.Changeset.get_argument(changeset, :bytes)
      }

      case Alexandria.Core.upload_original_file(params, actor: actor) do
        {:ok, _file} -> {:ok, document}
        {:error, reason} -> {:error, reason}
      end
    end)
  end
end
