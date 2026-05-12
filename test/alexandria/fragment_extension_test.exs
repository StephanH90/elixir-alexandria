defmodule Alexandria.FragmentExtensionTest do
  use ExUnit.Case, async: true

  describe "with no fragments registered" do
    test "Alexandria.Core compiles and has no resources" do
      # If the extension or its transformer was broken, the application
      # would fail to load and we wouldn't get here.
      assert Code.ensure_loaded?(Alexandria.Core)
      assert Ash.Domain.Info.resources(Alexandria.Core) == []
    end

    test "FragmentExtension exposes its transformer" do
      assert Alexandria.FragmentExtension.Transformer in Alexandria.FragmentExtension.transformers()
    end
  end
end
