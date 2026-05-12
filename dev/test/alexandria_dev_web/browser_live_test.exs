defmodule AlexandriaDevWeb.BrowserLiveTest do
  use AlexandriaDevWeb.ConnCase, async: false

  setup do
    scope = AlexandriaDev.demo_scope()

    {:ok, cat} =
      Alexandria.Core.create_root_category(
        %{id: "intern", name: %{"en" => "Intern"}, color: "#000000"},
        scope: scope
      )

    {:ok, doc} =
      Alexandria.Core.create_document(
        %{title: %{"en" => "Doc A"}, category_id: cat.id},
        scope: scope
      )

    {:ok, %{category: cat, document: doc}}
  end

  test "selecting a category lists documents", %{conn: conn} do
    conn
    |> visit("/")
    |> click_link("Intern")
    |> assert_has("a", text: "Doc A")
  end

  test "selecting a document adds it to the URL and opens the detail panel", %{conn: conn} do
    conn
    |> visit("/")
    |> click_link("Intern")
    |> click_link("Doc A")
    |> assert_has("article h4", text: "Doc A")
  end
end
