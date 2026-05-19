defmodule Alexandria.Core.Resource.Tag.Info do
  @moduledoc "Introspection helpers for `Alexandria.Core.Resource.Tag`."
  use Spark.InfoGenerator,
    extension: Alexandria.Core.Resource.Tag,
    sections: [:alexandria_tag]
end
