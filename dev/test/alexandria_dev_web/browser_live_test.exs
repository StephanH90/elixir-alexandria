defmodule AlexandriaDevWeb.BrowserLiveTest do
  use AlexandriaDevWeb.ConnCase, async: false

  alias Alexandria.Core.{Category, Document}

  setup do
    scope = AlexandriaDev.demo_scope()

    {:ok, cat} =
      Ash.create(Category, %{id: "intern", name: %{"en" => "Intern"}, color: "#000000"},
        action: :create_root,
        scope: scope
      )

    {:ok, doc} =
      Ash.create(Document, %{title: %{"en" => "Doc A"}, category_id: cat.id},
        action: :create,
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
