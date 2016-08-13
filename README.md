# UUID v5 Ecto Type

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

* Add `uuid5` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:uuid5, "~> 1.0"]
end
```

* Ensure `uuid5` is started before your application:

```elixir
def application do
  [applications: [:uuid5]]
end
```

## Usage

* Set UUID5 as field type:

```elixir
schema "users" do
  field :uuid_field, UUID5
end
```
