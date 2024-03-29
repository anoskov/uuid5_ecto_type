# UUID5 Ecto Type

UUID v5 type for Ecto.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

* Add `uuid5` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:uuid5, "~> 1.2"}]
end
```

## Usage

* Generate UUID5 string based on DNS

```elixir
iex(1)> UUID5.generate
"96bcc916-6bbc-5f61-8d88-bd83ed4b0b17"
```

* Generate UUID5 string based on DNS without dashes

```elixir
iex(1)> UUID5.generate(:hex)
"96bcc9166bbc5f618d88bd83ed4b0b17"
```

* Set UUID5 type for field in your model

```elixir
defmodule Project.User do
  use Project.Web, :model

  schema "users" do
    field :uuid_field, UUID5
  end
end
```
