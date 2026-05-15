defmodule AlexandriaDev.Scope do
  defstruct [:locale]

  defimpl Ash.Scope.ToOpts do
    def get_actor(_), do: {:ok, nil}
    def get_tenant(_), do: {:ok, nil}
    def get_context(%{locale: locale}), do: {:ok, %{shared: %{locale: locale}}}
    def get_tracer(_), do: :error
    def get_authorize?(_), do: :error
  end
end
