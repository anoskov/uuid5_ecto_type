defmodule UUID5 do
  @moduledoc """
  An Ecto type for UUIDs v5 strings.
  """

  if Code.ensure_loaded?(Ecto.Type) do
    @behaviour Ecto.Type
  end

  @type t :: <<_::288>>

  @doc """
  The Ecto type.
  """
  def type, do: :uuid5

  @doc """
  Casts to UUID.
  """
  def cast(<< _::64, ?-, _::32, ?-, _::32, ?-, _::32, ?-, _::96 >> = u) do
    if hex?(u), do: {:ok, u}, else: :error
  end
  def cast(_), do: :error

  defp hex?(u) do
    u
    |> :binary.bin_to_list()
    |> Enum.all?(fn c ->
      c == ?- or c in ?0..?9 or c in ?a..?f or c in ?A..?F
    end)
  end

  @doc """
  Converts a string representing a UUID into a binary.
  """
  def dump(uuid) do
    {:ok, UUID.string_to_binary!(uuid)}
  rescue
    ArgumentError -> :error
  end

  @doc """
  Converts a binary UUID into a string.
  """
  def load(<<_::128>> = uuid) do
   {:ok, UUID.binary_to_string!(uuid)}
  end
  def load(<<_::64, ?-, _::32, ?-, _::32, ?-, _::32, ?-, _::96>> = string) do
    raise "trying to load string UUID as Ecto.UUID: #{inspect string}. " <>
          "Maybe you wanted to declare :uuid as your database field?"
  end
  def load(%{__struct__: Ecto.Query.Tagged, type: :uuid5, value: uuid}) do
    {:ok, UUID.binary_to_string!(uuid)}
  end
  def load(_), do: :error

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2

  @doc """
  Generates a version 5 (dns) UUID.
  """
  def generate do
    UUID.uuid5(:dns, UUID.uuid4)
  end

  @doc """
  Generates a version 5 (dns) UUID without dashes.
  """
  def generate(:hex) do
    UUID.uuid5(:dns, UUID.uuid4, :hex)
  end

  def autogenerate, do: generate()
end
