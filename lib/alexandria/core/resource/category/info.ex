defmodule Alexandria.Core.Resource.Category.Info do
  @moduledoc "Introspection helpers for `Alexandria.Core.Resource.Category`."
  use Spark.InfoGenerator,
    extension: Alexandria.Core.Resource.Category,
    sections: [:alexandria_category]
end
