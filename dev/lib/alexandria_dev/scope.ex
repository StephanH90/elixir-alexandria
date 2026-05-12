defmodule AlexandriaDev.Scope do
  defstruct [:actor, :locale]
end

defimpl Ash.Scope.ToOpts, for: AlexandriaDev.Scope do
  def get_actor(%{actor: a}), do: {:ok, a}
  def get_tenant(_), do: :error
  def get_context(%{locale: l}), do: {:ok, %{shared: %{locale: l}}}
  def get_authorize?(_), do: :error
  def get_tracer(_), do: :error
end
