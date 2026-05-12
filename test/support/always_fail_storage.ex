defmodule Alexandria.Test.AlwaysFailStorage do
  @behaviour Alexandria.Storage

  @impl true
  def put(_, _, _), do: {:error, :forced_failure}
  @impl true
  def delete(_), do: :ok
  @impl true
  def presigned_url(_, _), do: {:ok, "https://example.invalid/forced"}
  @impl true
  def exists?(_), do: false
end
