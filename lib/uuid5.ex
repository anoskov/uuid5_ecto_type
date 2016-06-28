defmodule UUID5 do

  @moduledoc """
  An Ecto type for UUIDs v5 strings.
  """

  @behaviour Ecto.Type

  @doc """
  The Ecto type.
  """
  def type, do: :uuid5

  @doc """
  Casts to UUID.
  """
  def cast(<< _::64, ?-, _::32, ?-, _::32, ?-, _::32, ?-, _::96 >> = u), do: {:ok, u}
  def cast(_), do: :error

  @doc """
  Converts a string representing a UUID into a binary.
  """
  def dump(uuid) do
    try do
      UUID.string_to_binary!(uuid)
    catch
      :error -> :error
    else
      binary ->
        {:ok, %Ecto.Query.Tagged{type: :uuid5, value: binary}}
    end
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
  def load(%Ecto.Query.Tagged{type: :uuid5, value: uuid}) do
    {:ok, UUID.binary_to_string!(uuid)}
  end
  def load(_), do: :error

  @doc """
  Generates a version 5 (dns) UUID.
  """
  def generate do
    UUID.uuid5(:dns, UUID.uuid4)
  end

end
