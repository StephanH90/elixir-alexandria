defmodule Alexandria.FragmentExtension.Transformer do
  @moduledoc false
  use Spark.Dsl.Transformer

  alias Spark.Dsl.Transformer, as: DslTransformer

  def transform(dsl_state) do
    module = DslTransformer.get_persisted(dsl_state, :module)
    otp_app = DslTransformer.get_persisted(dsl_state, :otp_app)

    fragments =
      case otp_app && Application.get_env(otp_app, module) do
        nil -> []
        config -> Keyword.get(config, :fragments, [])
      end

    {:ok, Spark.Dsl.handle_fragments(dsl_state, fragments)}
  end
end
