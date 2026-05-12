defmodule Alexandria.Core do
  use Ash.Domain,
    otp_app: :alexandria,
    extensions: [Alexandria.FragmentExtension]

  resources do
    resource Alexandria.Core.Category
    resource Alexandria.Core.TagSynonymGroup
    resource Alexandria.Core.Tag
    resource Alexandria.Core.Mark
    resource Alexandria.Core.Document
    resource Alexandria.Core.DocumentTag
    resource Alexandria.Core.DocumentMark
  end
end
