defmodule Alexandria.Storage.InMemory do
  @behaviour Alexandria.Storage

  use Agent

  def start_link(_), do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  @impl true
  def put(key, content, _opts) when is_binary(content) do
    ensure_started()
    Agent.update(__MODULE__, &Map.put(&1, key, content))
    :ok
  end

  def put(key, {:file, path}, opts), do: put(key, File.read!(path), opts)

  @impl true
  def delete(key) do
    ensure_started()
    Agent.update(__MODULE__, &Map.delete(&1, key))
    :ok
  end

  @impl true
  def presigned_url(key, _opts) do
    {:ok, "inmemory://" <> key}
  end

  @impl true
  def exists?(key) do
    ensure_started()
    Agent.get(__MODULE__, &Map.has_key?(&1, key))
  end

  defp ensure_started do
    case Process.whereis(__MODULE__) do
      nil -> start_link([])
      _ -> :ok
    end
  end
end
