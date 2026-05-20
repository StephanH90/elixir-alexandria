defmodule AlexandriaDev.Core.Tag do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: AshPostgres.DataLayer,
    extensions: [Alexandria.Core.Resource.Tag]

  postgres do
    table "tags"
    repo AlexandriaDev.Repo
  end

  alexandria_tag do
    tag_synonym_group_resource AlexandriaDev.Core.TagSynonymGroup
  end
end
