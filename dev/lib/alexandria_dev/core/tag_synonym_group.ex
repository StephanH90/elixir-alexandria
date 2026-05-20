defmodule AlexandriaDev.Core.TagSynonymGroup do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: AshPostgres.DataLayer,
    extensions: [Alexandria.Core.Resource.TagSynonymGroup]

  postgres do
    table "tag_synonym_groups"
    repo AlexandriaDev.Repo
  end

  alexandria_tag_synonym_group do
    tag_resource AlexandriaDev.Core.Tag
  end
end
