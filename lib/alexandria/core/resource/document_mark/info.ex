defmodule Alexandria.Core.Resource.DocumentMark.Info do
  @moduledoc "Introspection helpers for `Alexandria.Core.Resource.DocumentMark`."
  use Spark.InfoGenerator,
    extension: Alexandria.Core.Resource.DocumentMark,
    sections: [:alexandria_document_mark]
end
