defmodule Alexandria.Core.Resource.TagSynonymGroup.Info do
  @moduledoc "Introspection helpers for `Alexandria.Core.Resource.TagSynonymGroup`."
  use Spark.InfoGenerator,
    extension: Alexandria.Core.Resource.TagSynonymGroup,
    sections: [:alexandria_tag_synonym_group]
end
