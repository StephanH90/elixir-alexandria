defmodule Alexandria.Core.File.Changes.PutBytes do
  @moduledoc false
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _ctx) do
    bytes = Ash.Changeset.get_argument(changeset, :bytes)
    key = Ecto.UUID.generate()

    case Alexandria.Storage.put(key, bytes) do
      :ok ->
        Ash.Changeset.change_attribute(changeset, :content, key)

      {:error, reason} ->
        Ash.Changeset.add_error(changeset,
          field: :bytes,
          message: "storage put failed: #{inspect(reason)}"
        )
    end
  end
end
