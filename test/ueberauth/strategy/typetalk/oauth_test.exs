defmodule Ueberauth.Strategy.Typetalk.OAuthTest do
  use ExUnit.Case

  doctest Ueberauth.Strategy.Typetalk.OAuth

  alias Ueberauth.Strategy.Typetalk.OAuth

  setup do
    Application.put_env(:ueberauth, OAuth,
      client_id: "CLIENT_ID",
      client_secret: "CLIENT_SECRET"
    )

    :ok
  end

  test "creates correct client" do
    client = OAuth.client()

    assert client.client_id == "CLIENT_ID"
    assert client.client_secret == "CLIENT_SECRET"

    assert client.site == "https://typetalk.com"
    assert client.authorize_url == "/oauth2/authorize"
    assert client.token_url == "/oauth2/access_token"
  end
end
