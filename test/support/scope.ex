defmodule Alexandria.Test.Scope do
  @moduledoc "Minimal scope struct for tests."
  defstruct [:actor, :locale]
end

defimpl Ash.Scope.ToOpts, for: Alexandria.Test.Scope do
  def get_actor(%{actor: actor}), do: {:ok, actor}
  def get_tenant(_), do: :error
  def get_context(%{locale: locale}), do: {:ok, %{shared: %{locale: locale}}}
  def get_authorize?(_), do: :error
  def get_tracer(_), do: :error
end
