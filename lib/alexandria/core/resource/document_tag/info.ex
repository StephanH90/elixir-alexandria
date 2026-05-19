defmodule Alexandria.Core.Resource.DocumentTag.Info do
  @moduledoc "Introspection helpers for `Alexandria.Core.Resource.DocumentTag`."
  use Spark.InfoGenerator,
    extension: Alexandria.Core.Resource.DocumentTag,
    sections: [:alexandria_document_tag]
end
