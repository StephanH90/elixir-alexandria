defmodule Alexandria.Core.Resource.Document.Info do
  @moduledoc "Introspection helpers for `Alexandria.Core.Resource.Document`."
  use Spark.InfoGenerator,
    extension: Alexandria.Core.Resource.Document,
    sections: [:alexandria_document]
end
