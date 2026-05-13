defmodule Alexandria.Core.File.Changes.ReplaceBytes do
  @moduledoc false
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _ctx) do
    bytes = Ash.Changeset.get_argument(changeset, :bytes)
    new_key = Ecto.UUID.generate()
    old_key = changeset.data.content
    checksum = :crypto.hash(:sha256, bytes) |> Base.encode16(case: :lower)

    changeset
    |> Ash.Changeset.change_attribute(:content, new_key)
    |> Ash.Changeset.change_attribute(:checksum, checksum)
    |> Ash.Changeset.after_action(fn _changeset, file ->
      case Alexandria.Storage.put(new_key, bytes) do
        :ok ->
          # Best-effort cleanup of the old object — failure here doesn't fail the action.
          if old_key, do: Alexandria.Storage.delete(old_key)
          {:ok, file}

        {:error, reason} ->
          {:error, "storage put failed: #{inspect(reason)}"}
      end
    end)
  end
end
