# Paapi5

![Build](https://img.shields.io/github/workflow/status/dallagi/paapi5/Elixir%20CI)
![Hex.pm](https://img.shields.io/hexpm/v/paapi5)

 A minimalistic Elixir library for the Amazon Product Advertising Api version 5.

## Installation

This package can be installed by adding `paapi5` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:paapi5, "~> 0.1.2"}
  ]
end
```

## Usage

Build a signed request for the Amazon Product Advertising API 5 (PAAPI5):

```elixir
  request =
    Paapi5.request(
      "<access_key>",
      "<secret_key>",
      "<partner_tag>",
      :us,
      "SearchItems",
      %{"Keywords" => "elixir in action"}
    )
```

You can then use a HTTP client of your choice to actually send this request, e.g.:

```elixir
  items = HTTPoison.request!(request.method, request.url, request.body, request.headers)
```

The marketplace can either be an atom (e.g., `:us`, `:it`, `:uk`, etc.) or a `Paapi5.Marketplace` struct
with the host and region (e.g., `%Paapi5.Marketplace{host: "webservices.amazon.it", region: "eu-west-1"}`).
The known marketplaces are `:au`, `:br`, `:ca`, `:fr`, `:de`, `:in`, `:it`, `:jp`, `:mx`, `:nl`, `:sg`, `:sa`, `:es`, `:se`, `:tr`, `:ae`, `:uk`, `:us`.

For a reference about operations and their parameters, see [the PAAPI5 documentation](https://webservices.amazon.com/paapi5/documentation/operations.html).

For working examples on usage of this library, see the [tests](https://github.com/dallagi/paapi5/blob/main/test/paapi5_test.exs).

## Development

Issues and contributions are very welcome!

To launch tests, run:

```bash
mix test
```

Tests require a valid set of credentials for the **Italian** PAAPI to be passed via environment variables:

```bash
export ACCESS_KEY="your-paapi-access-key"
export SECRET_KEY="your-paapi-secret-key"
export PARTNER_TAG="your-paapi-partner-tag"
```
