defmodule AlexandriaDev.Repo do
  @moduledoc """
  Consumer-owned AshPostgres repo for the dev app.

  Hosts the inverted `AlexandriaDev.Core.*` resources. Kept distinct from
  `Alexandria.Repo` (the upstream library's repo, still used by the legacy
  `Alexandria.Core.*` resources) so migrations and snapshots from this app
  don't collide with the library's own.
  """
  use AshPostgres.Repo, otp_app: :alexandria_dev

  def installed_extensions, do: ["ash-functions", "uuid-ossp", "citext"]
  def min_pg_version, do: %Version{major: 14, minor: 0, patch: 0}
  def prefer_transaction?, do: false
end
