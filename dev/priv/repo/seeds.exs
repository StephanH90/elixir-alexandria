alias Alexandria.Core.Category

scope = AlexandriaDev.demo_scope()

dump_path = Path.expand("~/Documents/camac/elixir/alexandria/demo/dump.json")
dump = dump_path |> File.read!() |> Jason.decode!()

dump
|> Enum.filter(&(&1["model"] == "alexandria_core.category"))
|> Enum.each(fn %{"pk" => id, "fields" => f} ->
  Ash.create!(
    Category,
    %{
      id: id,
      name: Jason.decode!(f["name"]),
      description: Jason.decode!(f["description"]),
      color: f["color"],
      metainfo: f["meta"] || %{}
    },
    action: :create_root,
    scope: scope
  )
end)

IO.puts("Seeded #{Category |> Ash.read!(scope: scope) |> length()} categories")

alias Alexandria.Core.Document

[first | _] = Category |> Ash.read!(scope: scope)

for i <- 1..3 do
  Ash.create!(
    Document,
    %{title: %{"en" => "Demo doc #{i}"}, date: ~D[2026-05-01], category_id: first.id},
    action: :create,
    scope: scope
  )
end

IO.puts("Seeded 3 demo documents in #{first.id}")
