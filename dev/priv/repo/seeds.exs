scope = AlexandriaDev.demo_scope()

categories = [
  %{
    slug: "beilagen-zum-gesuch",
    name: %{"de-ch" => "Beilagen zum Gesuch", "en" => "Application attachments"},
    description: %{
      "de-ch" =>
        "Diese Dokumente wurden vom Gesuchstellenden hochgeladen und sind für alle am Verfahren beteiligten Behörden einsehbar.",
      "en" => "Uploaded by the applicant, visible to all authorities involved."
    },
    color: "#9cdd69"
  },
  %{
    slug: "nachforderung",
    name: %{"de-ch" => "Nachforderung", "en" => "Supplementary requests"},
    description: %{
      "de-ch" => "Dokumente aus Nachforderungen, sichtbar für alle Beteiligten.",
      "en" => "Documents from follow-up requests, visible to all parties."
    },
    color: "#66cfc9"
  },
  %{
    slug: "alle-beteiligten",
    name: %{"de-ch" => "Alle Beteiligten", "en" => "All parties"},
    description: %{
      "de-ch" => "Von der Gemeinde hochgeladene Dokumente für alle Rollen.",
      "en" => "Municipality uploads visible to every role."
    },
    color: "#cb68c1"
  },
  %{
    slug: "intern",
    name: %{"de-ch" => "Intern", "en" => "Internal"},
    description: %{
      "de-ch" => "Nur innerhalb der eigenen Organisation sichtbar.",
      "en" => "Visible only within your own organisation."
    },
    color: "#db8b72"
  }
]

existing = Alexandria.Core.list_root_categories!(scope: scope)

if existing == [] do
  Enum.each(categories, fn attrs ->
    Alexandria.Core.create_root_category!(
      Map.put(attrs, :metainfo, %{}),
      scope: scope
    )
  end)

  IO.puts("Seeded #{length(categories)} categories")

  [first | _] = Alexandria.Core.list_root_categories!(scope: scope)

  for i <- 1..3 do
    Alexandria.Core.create_document!(
      %{
        title: %{"en" => "Demo doc #{i}", "de-ch" => "Demo-Dokument #{i}"},
        date: ~D[2026-05-01],
        category_id: first.slug
      },
      scope: scope
    )
  end

  IO.puts("Seeded 3 demo documents in #{first.slug}")
else
  IO.puts("Skipping seeds: #{length(existing)} categories already present")
end
