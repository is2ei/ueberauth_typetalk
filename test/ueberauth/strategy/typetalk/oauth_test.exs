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

  test "authorize_url!" do
    opts = [redirect_uri: "http://localhost:8484/auth/typetalk/callback", scope: "my topic.read"]
    authorize_url = OAuth.authorize_url!(opts)

    assert authorize_url ==
             "https://typetalk.com/oauth2/authorize?client_id=CLIENT_ID&redirect_uri=http%3A%2F%2Flocalhost%3A8484%2Fauth%2Ftypetalk%2Fcallback&response_type=code&scope=my+topic.read"
  end
end
