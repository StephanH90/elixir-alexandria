defmodule AlexandriaDev.Core.TagSynonymGroup do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: Ash.DataLayer.Ets,
    extensions: [Alexandria.Core.Resource.TagSynonymGroup]

  alexandria_tag_synonym_group do
    tag_resource AlexandriaDev.Core.Tag
  end
end
