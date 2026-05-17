defmodule Alexandria.Calculations.LocalizedField do
  @moduledoc """
  Locale-aware string accessor for multilingual JSONB attributes.

  Reads locale from `context.source_context[:shared][:locale]` (set by the
  scope's `Ash.Scope.ToOpts.get_context/1` implementation). Defaults to "en"
  when no scope is supplied.
  """
  use Ash.Resource.Calculation

  @impl true
  def init(opts) do
    case Keyword.fetch(opts, :attribute) do
      {:ok, attr} when is_atom(attr) -> {:ok, %{attribute: attr}}
      _ -> {:error, "must provide :attribute option"}
    end
  end

  @impl true
  def load(_query, %{attribute: attr}, _context), do: [attr]

  @impl true
  def calculate(records, %{attribute: attr}, context) do
    locale = locale_from(context)

    Enum.map(records, fn record ->
      record
      |> Map.get(attr)
      |> Alexandria.Types.Multilingual.get(locale)
    end)
  end

  @impl true
  def expression(opts, context) do
    locale = locale_from(context)
    attr = opts[:attribute]

    # looks up language and fallsback to "en"
    # TODO: Inject fallback language (via Gettext?)
    expr(
      if is_nil(get_path(^ref(attr), [^locale])) do
        get_path(^ref(attr), ["en"])
      else
        get_path(^ref(attr), [^locale])
      end
    )
  end

  defp locale_from(%{source_context: %{shared: %{locale: locale}}}) when is_binary(locale),
    do: locale

  defp locale_from(_), do: "en"
end
