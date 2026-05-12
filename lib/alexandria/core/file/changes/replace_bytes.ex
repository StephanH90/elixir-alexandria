defmodule Alexandria.Core.File.Changes.ReplaceBytes do
  @moduledoc false
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _ctx) do
    bytes = Ash.Changeset.get_argument(changeset, :bytes)
    new_key = Ecto.UUID.generate()
    old_key = Ash.Changeset.get_attribute(changeset, :content)

    case Alexandria.Storage.put(new_key, bytes) do
      :ok ->
        changeset
        |> Ash.Changeset.change_attribute(:content, new_key)
        |> Ash.Changeset.after_action(fn _, file ->
          if old_key, do: Alexandria.Storage.delete(old_key)
          {:ok, file}
        end)

      {:error, reason} ->
        Ash.Changeset.add_error(changeset,
          field: :bytes,
          message: "storage put failed: #{inspect(reason)}"
        )
    end
  end
end
