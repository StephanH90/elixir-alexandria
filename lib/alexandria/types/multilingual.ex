defmodule Alexandria.Types.Multilingual do
  @moduledoc """
  Multilingual JSONB attribute: keys are locale strings, values are strings.
  Matches Django alexandria's `{"de-ch": "...", "en": "..."}` shape.
  """
  use Ash.Type

  @impl true
  def storage_type(_), do: :map

  @impl true
  def cast_input(nil, _), do: {:ok, nil}

  def cast_input(value, _) when is_map(value) do
    if Enum.all?(value, fn {k, v} -> is_binary(k) and is_binary(v) end) do
      {:ok, value}
    else
      {:error, "all keys and values must be strings"}
    end
  end

  def cast_input(_, _), do: {:error, "must be a map"}

  @impl true
  def cast_stored(nil, _), do: {:ok, nil}
  def cast_stored(value, _) when is_map(value), do: {:ok, value}

  @impl true
  def dump_to_native(nil, _), do: {:ok, nil}
  def dump_to_native(value, _) when is_map(value), do: {:ok, value}

  @doc "Return the value for `locale` falling back to other available locales."
  def get(nil, _locale), do: nil

  def get(map, locale) when is_map(map) do
    Map.get(map, locale) || Map.get(map, "en") || map |> Map.values() |> List.first()
  end
end
