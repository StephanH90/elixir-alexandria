defmodule Alexandria.Core.Resource.File.Info do
  @moduledoc "Introspection helpers for `Alexandria.Core.Resource.File`."
  use Spark.InfoGenerator,
    extension: Alexandria.Core.Resource.File,
    sections: [:alexandria_file]
end
