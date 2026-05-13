defmodule Alexandria.Calculations.HumanSize do
  @moduledoc """
  Formats a byte-count `:size` attribute as a short human string
  (`"42 B"`, `"3.1 KB"`, `"7.8 MB"`).
  """
  use Ash.Resource.Calculation

  @impl true
  def load(_query, _opts, _context), do: [:size]

  @impl true
  def calculate(records, _opts, _context) do
    Enum.map(records, &format(&1.size))
  end

  defp format(nil), do: "?"
  defp format(n) when n < 1024, do: "#{n} B"
  defp format(n) when n < 1024 * 1024, do: "#{Float.round(n / 1024, 1)} KB"
  defp format(n), do: "#{Float.round(n / 1024 / 1024, 1)} MB"
end
