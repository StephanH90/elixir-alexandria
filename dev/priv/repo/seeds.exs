scope = AlexandriaDev.demo_scope()

dump_path = Path.expand("~/Documents/camac/elixir/alexandria/demo/dump.json")
dump = dump_path |> File.read!() |> Jason.decode!()

dump
|> Enum.filter(&(&1["model"] == "alexandria_core.category"))
|> Enum.each(fn %{"pk" => id, "fields" => f} ->
  Alexandria.Core.create_root_category!(
    %{
      id: id,
      name: Jason.decode!(f["name"]),
      description: Jason.decode!(f["description"]),
      color: f["color"],
      metainfo: f["meta"] || %{}
    },
    scope: scope
  )
end)

IO.puts("Seeded #{Alexandria.Core.list_root_categories!(scope: scope) |> length()} categories")

[first | _] = Alexandria.Core.list_root_categories!(scope: scope)

for i <- 1..3 do
  Alexandria.Core.create_document!(
    %{title: %{"en" => "Demo doc #{i}"}, date: ~D[2026-05-01], category_id: first.id},
    scope: scope
  )
end

IO.puts("Seeded 3 demo documents in #{first.id}")
