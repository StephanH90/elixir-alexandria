defmodule AlexandriaDev.Core.Tag do
  @moduledoc false
  use Ash.Resource,
    otp_app: :alexandria_dev,
    domain: AlexandriaDev.Core,
    data_layer: Ash.DataLayer.Ets,
    extensions: [Alexandria.Core.Resource.Tag]

  alexandria_tag do
    tag_synonym_group_resource AlexandriaDev.Core.TagSynonymGroup
  end
end
