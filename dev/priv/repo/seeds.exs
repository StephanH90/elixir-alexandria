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
