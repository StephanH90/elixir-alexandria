defmodule Alexandria.FragmentExtension do
  @moduledoc false
  use Spark.Dsl.Extension,
    transformers: [Alexandria.FragmentExtension.Transformer]
end
