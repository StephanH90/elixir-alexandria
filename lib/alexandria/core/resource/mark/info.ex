defmodule Alexandria.Core.Resource.Mark.Info do
  @moduledoc "Introspection helpers for `Alexandria.Core.Resource.Mark`."
  use Spark.InfoGenerator,
    extension: Alexandria.Core.Resource.Mark,
    sections: [:alexandria_mark]
end
