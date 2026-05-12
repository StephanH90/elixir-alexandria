defmodule AlexandriaDev do
  def demo_scope do
    %AlexandriaDev.Scope{
      actor: %{id: "demo-user", roles: [:admin]},
      locale: "en"
    }
  end
end
