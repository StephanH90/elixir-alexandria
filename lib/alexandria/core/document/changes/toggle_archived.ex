defmodule Alexandria.Core.Document.Changes.ToggleArchived do
  @moduledoc false
  use Ash.Resource.Change

  @impl true
  def change(changeset, opts, _context) do
    flag = Keyword.fetch!(opts, :flag)

    Ash.Changeset.before_action(changeset, fn cs ->
      meta = Ash.Changeset.get_attribute(cs, :metainfo) || %{}

      new_meta =
        case flag do
          :on -> Map.put(meta, "archived_at", DateTime.utc_now() |> DateTime.to_iso8601())
          :off -> Map.delete(meta, "archived_at")
        end

      Ash.Changeset.change_attribute(cs, :metainfo, new_meta)
    end)
  end
end
