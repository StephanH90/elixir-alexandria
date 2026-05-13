defmodule Alexandria.Core.File.Changes.PutBytes do
  @moduledoc false
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _ctx) do
    bytes = Ash.Changeset.get_argument(changeset, :bytes)
    key = Ecto.UUID.generate()
    checksum = :crypto.hash(:sha256, bytes) |> Base.encode16(case: :lower)

    changeset
    |> Ash.Changeset.change_attribute(:content, key)
    |> Ash.Changeset.change_attribute(:checksum, checksum)
    |> Ash.Changeset.after_action(fn _changeset, file ->
      case Alexandria.Storage.put(key, bytes) do
        :ok ->
          {:ok, file}

        {:error, reason} ->
          {:error, "storage put failed: #{inspect(reason)}"}
      end
    end)
  end
end
