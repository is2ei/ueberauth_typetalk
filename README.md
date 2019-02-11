Überauth Typetalk
===
[![Hex Version](http://img.shields.io/hexpm/v/ueberauth_typetalk.svg)][hex]

[hex]: https://hex.pm/packages/ueberauth_typetalk

Typetalk OAuth2 Strategy for Überauth 

## Installation

1. Setup your application at [Typetalk Developer page](https://typetalk.com/my/develop/applications).

2. Add ueberauth_typetalk to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ueberauth_typetalk, "~> 0.1"}]
end
```

3. Add the strategy to your applications:

```elixir
def application do
  [application: [:ueberauth_typetalk]]
end
```

4. Add Typetalk to your Überauth configuration:

```elixir
config :ueberauth, Ueberauth,
  providers: [
    typetalk: {Ueberauth.Strategy.Typetalk, []}
  ]
```

5. Update your provider configuration:

```elixir
config :ueberauth, Ueberauth.Strategy.Typetalk.OAuth,
  client_id: System.get_env("TYPETALK_CLIENT_ID")
  client_secret: System.get_env("TYPETALK_CLIENT_SECRET")
```

6. Include the Überauth plug in your controller:

```elixir
defmodule MyApp.AuthController do
  use MyApp.Web, :controller

  pipeline :browser do
    plug Ueberauth
    ...
  end
end
```

7. Create the request and callback routes if you haven't already:

```elixir
scope "/auth", MyApp do
  pipe_through :browser

  get "/:provider", AuthController, :request
  get "/:provider/callback", AuthController, :callback
end
```

8. Your controller needs to implement callbacks to deal with `Ueberauth.Auth` and `Ueberauth.Failure` responses.

For an example implementation see [the Example applciation](https://github.com/is2ei/ueberauth_typetalk_example).

