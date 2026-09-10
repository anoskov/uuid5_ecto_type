defmodule UUID5Test do
  use ExUnit.Case, async: true

  doctest UUID5

  # Hyphens in the right places, not one hexadecimal character.
  @shaped "zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz"
  @uuid "6ba7b810-9dad-11d1-80b4-00c04fd430c8"

  describe "cast/1" do
    test "accepts a uuid" do
      assert {:ok, @uuid} == UUID5.cast(@uuid)
    end

    test "accepts a uuid in upper case, unchanged" do
      upper = String.upcase(@uuid)

      assert {:ok, upper} == UUID5.cast(upper)
    end

    test "accepts what generate/0 produces" do
      uuid = UUID5.generate()

      assert {:ok, uuid} == UUID5.cast(uuid)
    end

    test "refuses a value with the shape of a uuid and no hexadecimal in it" do
      assert :error == UUID5.cast(@shaped)
    end

    test "refuses a value with one character out of range" do
      assert :error == UUID5.cast("6ba7b810-9dad-11d1-80b4-00c04fd430cg")
    end

    test "refuses a value of the wrong length" do
      assert :error == UUID5.cast("6ba7b810-9dad-11d1-80b4")
    end

    test "refuses a term that is not a binary" do
      assert :error == UUID5.cast(nil)
      assert :error == UUID5.cast(42)
    end

    test "accepts only what dump/1 can dump" do
      # The two are one contract: Ecto casts a value and then dumps it, so a
      # value cast/1 accepts and dump/1 cannot convert becomes an exception
      # from inside Ecto rather than a changeset error.
      for value <- [@uuid, String.upcase(@uuid), @shaped, "", "not a uuid"] do
        assert (UUID5.cast(value) != :error) == (UUID5.dump(value) != :error),
               "cast/1 and dump/1 disagree about #{inspect(value)}"
      end
    end
  end

  describe "dump/1" do
    test "converts a uuid to sixteen bytes" do
      assert {:ok, binary} = UUID5.dump(@uuid)
      assert byte_size(binary) == 16
    end

    test "answers :error for a value it cannot convert, rather than raising" do
      assert :error == UUID5.dump(@shaped)
    end

    test "answers :error for a term that is not a uuid string" do
      assert :error == UUID5.dump("")
      assert :error == UUID5.dump(nil)
    end
  end

  describe "the rest of the Ecto.Type callbacks" do
    test "type/0 names the column type" do
      assert :uuid5 == UUID5.type()
    end

    test "autogenerate/0 produces a uuid this type accepts" do
      uuid = UUID5.autogenerate()

      assert {:ok, uuid} == UUID5.cast(uuid)
    end

    test "embed_as/1 keeps the value as it is" do
      assert :self == UUID5.embed_as(:json)
    end

    test "equal?/2 compares the two terms" do
      assert UUID5.equal?(@uuid, @uuid)
      refute UUID5.equal?(@uuid, String.upcase(@uuid))
    end
  end

  describe "generate/1" do
    test ":hex leaves the hyphens out" do
      hex = UUID5.generate(:hex)

      assert byte_size(hex) == 32
      refute String.contains?(hex, "-")
    end
  end

  describe "load/1" do
    test "converts sixteen bytes back to a uuid" do
      {:ok, binary} = UUID5.dump(@uuid)

      assert {:ok, @uuid} == UUID5.load(binary)
    end

    test "refuses anything else" do
      assert :error == UUID5.load(<<1, 2, 3>>)
    end

    test "converts a tagged query value" do
      {:ok, binary} = UUID5.dump(@uuid)
      # Written as a plain map, not as the struct: ecto is an optional
      # dependency, so the module is not there to expand. The clause under test
      # matches it the same way, and for the same reason.
      tagged = %{__struct__: Ecto.Query.Tagged, type: :uuid5, value: binary}

      assert {:ok, @uuid} == UUID5.load(tagged)
    end

    test "says so when a string uuid is loaded as if it were binary" do
      assert_raise RuntimeError, ~r/declare :uuid as your database field/, fn ->
        UUID5.load(@uuid)
      end
    end
  end
end
