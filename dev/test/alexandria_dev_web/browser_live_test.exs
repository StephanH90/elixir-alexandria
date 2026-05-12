defmodule AlexandriaDevWeb.BrowserLiveTest do
  use AlexandriaDevWeb.ConnCase, async: false

  test "page renders the seeded categories", %{conn: conn} do
    {:ok, _} =
      Ash.create(
        Alexandria.Core.Category,
        %{id: "test-c", name: %{"en" => "TestCat"}, color: "#000000"},
        action: :create_root,
        scope: AlexandriaDev.demo_scope()
      )

    conn
    |> visit("/")
    |> assert_has("h1", text: "Alexandria Dev")
    |> assert_has("li", text: "TestCat")
  end
end
