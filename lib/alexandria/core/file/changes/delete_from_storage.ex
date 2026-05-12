defmodule Alexandria.Core.File.Changes.DeleteFromStorage do
  @moduledoc false
  use Ash.Resource.Change
  require Logger

  @impl true
  def change(changeset, _opts, _ctx) do
    key = Ash.Changeset.get_attribute(changeset, :content)

    Ash.Changeset.after_action(changeset, fn _, file ->
      if key do
        case Alexandria.Storage.delete(key) do
          :ok ->
            :ok

          {:error, reason} ->
            Logger.warning("alexandria storage delete failed for key=#{key}: #{inspect(reason)}")
        end
      end

      {:ok, file}
    end)
  end
end
