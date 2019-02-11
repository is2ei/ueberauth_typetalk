defmodule Ueberauth.Strategy.TypetalkTest do
  use ExUnit.Case

  doctest Ueberauth.Strategy.Typetalk

  test "is Truth" do
    assert 1 + 1 == 2
  end

  describe "credentials" do
    test "are returned" do
      conn =
        %Plug.Conn{}
        |> Plug.Conn.put_private(:typetalk_token, %{
          access_token: "access-token",
          refresh_token: "refresh-token",
          expires: false,
          expires_at: Time.utc_now(),
          other_params: %{}
        })

      creds = Ueberauth.Strategy.Typetalk.credentials(conn)
      assert creds.token == "access-token"
      assert creds.refresh_token == "refresh-token"
      assert creds.expires == true
      assert creds.scopes == [""]
    end
  end

  describe "info" do
    test "is returned" do
      conn =
        %Plug.Conn{}
        |> Plug.Conn.put_private(:typetalk_user, %{
          "fullName" => "Issei Horie",
          "name" => "is2ei",
          "mailAddress" => "is2ei@example.com",
          "imageUrl" => "https://typetalk.com/accounts/2500/profile_image.png?t=1454061730873"
        })

      info = Ueberauth.Strategy.Typetalk.info(conn)
      assert info.name == "Issei Horie"
      assert info.nickname == "is2ei"
      assert info.email == "is2ei@example.com"
      assert info.image == "https://typetalk.com/accounts/2500/profile_image.png?t=1454061730873"
    end
  end
end
