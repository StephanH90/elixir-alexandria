defmodule Alexandria.FragmentExtensionTest do
  use ExUnit.Case, async: false

  defmodule PingFragment do
    use Spark.Dsl.Fragment, of: Ash.Resource

    actions do
      action :ping, :string do
        run fn _input, _context -> {:ok, "pong"} end
      end
    end
  end

  # Register the fragment BEFORE the resource module is defined, so the
  # FragmentExtension transformer picks it up at compile time.
  Application.put_env(:alexandria, __MODULE__.PingResource, fragments: [PingFragment])

  defmodule PingResource do
    use Ash.Resource,
      otp_app: :alexandria,
      domain: nil,
      validate_domain_inclusion?: false,
      extensions: [Alexandria.FragmentExtension]

    attributes do
      uuid_primary_key :id
    end

    actions do
      defaults [:read]
    end
  end

  defmodule NoFragmentsResource do
    use Ash.Resource,
      otp_app: :alexandria,
      domain: nil,
      validate_domain_inclusion?: false,
      extensions: [Alexandria.FragmentExtension]

    attributes do
      uuid_primary_key :id
    end

    actions do
      defaults [:read]
    end
  end

  test "fragment-defined actions appear on the host resource" do
    action_names =
      PingResource
      |> Ash.Resource.Info.actions()
      |> Enum.map(& &1.name)

    assert :ping in action_names
  end

  test "with no fragments registered, the host resource has only its base actions" do
    action_names =
      NoFragmentsResource
      |> Ash.Resource.Info.actions()
      |> Enum.map(& &1.name)

    refute :ping in action_names
    assert :read in action_names
  end
end
