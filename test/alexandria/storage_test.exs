defmodule Alexandria.StorageTest.SharedAssertions do
  defmacro __using__(adapter: adapter) do
    quote do
      @adapter unquote(adapter)

      setup do
        prior = Application.get_env(:alexandria, :storage, [])
        Application.put_env(:alexandria, :storage, Keyword.put(prior, :adapter, @adapter))
        on_exit(fn -> Application.put_env(:alexandria, :storage, prior) end)
        :ok
      end

      test "put then exists? returns true" do
        key = "test-#{System.unique_integer([:positive])}"
        assert :ok = Alexandria.Storage.put(key, "hello bytes")
        assert Alexandria.Storage.exists?(key)
      end

      test "delete removes the object" do
        key = "test-#{System.unique_integer([:positive])}"
        :ok = Alexandria.Storage.put(key, "x")
        :ok = Alexandria.Storage.delete(key)
        refute Alexandria.Storage.exists?(key)
      end

      test "presigned_url returns a string url" do
        key = "test-#{System.unique_integer([:positive])}"
        :ok = Alexandria.Storage.put(key, "x")
        assert {:ok, url} = Alexandria.Storage.presigned_url(key)
        assert is_binary(url)
      end
    end
  end
end

defmodule Alexandria.StorageTest do
  use ExUnit.Case, async: false

  describe "InMemory adapter (test support)" do
    use Alexandria.StorageTest.SharedAssertions, adapter: Alexandria.Test.InMemoryStorage
  end
end
