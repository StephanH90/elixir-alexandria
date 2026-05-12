defmodule AlexandriaDev.Storage.ExAws do
  @moduledoc """
  ExAws/S3 implementation of `Alexandria.Storage`.

  Lives in the dev sub-app so the library itself does not depend on
  `:ex_aws`. Consumers that want S3 storage either pull in this module
  (via `{:alexandria_dev, ...}`) or roll their own adapter.
  """

  @behaviour Alexandria.Storage

  @impl true
  def put(key, content, _opts) when is_binary(content) do
    bucket = config!(:bucket)

    bucket
    |> ExAws.S3.put_object(key, content)
    |> request_with_config()
    |> case do
      {:ok, _} -> :ok
      {:error, reason} -> {:error, reason}
    end
  end

  def put(key, {:file, path}, _opts) do
    bucket = config!(:bucket)

    path
    |> ExAws.S3.Upload.stream_file()
    |> ExAws.S3.upload(bucket, key)
    |> request_with_config()
    |> case do
      {:ok, _} -> :ok
      {:error, reason} -> {:error, reason}
    end
  end

  @impl true
  def delete(key) do
    bucket = config!(:bucket)

    bucket
    |> ExAws.S3.delete_object(key)
    |> request_with_config()
    |> case do
      {:ok, _} -> :ok
      {:error, reason} -> {:error, reason}
    end
  end

  @impl true
  def presigned_url(key, opts \\ []) do
    bucket = config!(:bucket)
    method = Keyword.get(opts, :method, :get)
    ttl = Keyword.get(opts, :ttl, config(:presigned_url_ttl_seconds, 3600))

    ExAws.Config.new(:s3, ex_aws_config_overrides())
    |> ExAws.S3.presigned_url(method, bucket, key, expires_in: ttl)
  end

  @impl true
  def exists?(key) do
    bucket = config!(:bucket)

    bucket
    |> ExAws.S3.head_object(key)
    |> request_with_config()
    |> case do
      {:ok, _} -> true
      _ -> false
    end
  end

  defp request_with_config(operation) do
    ExAws.request(operation, ex_aws_config_overrides())
  end

  defp ex_aws_config_overrides do
    endpoint = config!(:endpoint_url)
    uri = URI.parse(endpoint)

    [
      access_key_id: config!(:access_key_id),
      secret_access_key: config!(:secret_access_key),
      region: config(:region, "garage"),
      scheme: "#{uri.scheme}://",
      host: uri.host,
      port: uri.port
    ]
  end

  defp config!(key) do
    config(key) || raise "missing :alexandria :storage config: #{key}"
  end

  defp config(key, default \\ nil) do
    Application.get_env(:alexandria, :storage)[key] || default
  end
end
