defmodule Alexandria.Storage do
  @moduledoc """
  Storage abstraction. Resource actions call this module; this module
  dispatches to the configured adapter.
  """

  @callback put(
              key :: String.t(),
              content :: binary | {:file, Path.t()} | Enumerable.t(),
              opts :: keyword
            ) :: :ok | {:error, term}
  @callback delete(key :: String.t()) :: :ok | {:error, term}
  @callback presigned_url(key :: String.t(), opts :: keyword) ::
              {:ok, String.t()} | {:error, term}
  @callback exists?(key :: String.t()) :: boolean

  def put(key, content, opts \\ []), do: adapter().put(key, content, opts)
  def delete(key), do: adapter().delete(key)
  def presigned_url(key, opts \\ []), do: adapter().presigned_url(key, opts)
  def exists?(key), do: adapter().exists?(key)

  defp adapter, do: Application.fetch_env!(:alexandria, :storage)[:adapter]
end
