defmodule Ueberauth.Strategy.TypetalkTest do
  use ExUnit.Case

  doctest Ueberauth.Strategy.Typetalk

  alias Ueberauth.Strategy.Typetalk.OAuth

  setup do
    Application.put_env(:ueberauth, OAuth,
      client_id: "CLIENT_ID",
      client_secret: "CLIENT_SECRET"
    )

    :ok
  end

  describe "handle_request!" do
    test "..." do
      # conn = %Plug.Conn{
      #   params: %{
      #     cliend_id: "12345",
      #     client_secret: "98765",
      #     redirect_uri: "http://localhost:4000/auth/typetalk/callback"
      #   }
      # }

      ### TODO: Fix error
      # result = Ueberauth.Strategy.Typetalk.handle_request!(conn)
      # assert result == nil
    end
  end

  describe "handle_callback!" do
    test "with no code" do
      conn = %Plug.Conn{}
      result = Ueberauth.Strategy.Typetalk.handle_callback!(conn)
      failure = result.assigns.ueberauth_failure
      assert length(failure.errors) == 1
      [no_code_error] = failure.errors

      assert no_code_error.message_key == "missing_code"
      assert no_code_error.message == "No code received"
    end

    ### TODO: Mock endpoint
    # test "with code" do
    #   conn = %Plug.Conn{
    #     params: %{
    #       "code" => "XXXXXXXXXX"
    #     }
    #   }

    #   result = Ueberauth.Strategy.Typetalk.handle_callback!(conn)
    #   assert result == "test"
    # end
  end

  describe "handle_cleanup!" do
    test "clears typetalk_user from conn" do
      conn =
        %Plug.Conn{}
        |> Plug.Conn.put_private(:typetalk_user, %{username: "is2ei"})

      result = Ueberauth.Strategy.Typetalk.handle_cleanup!(conn)
      assert result.private.typetalk_user == nil
    end
  end

  describe "uid" do
    # uid = "abcd1234abcd1234"

    conn =
      %Plug.Conn{}
      |> Plug.Conn.put_private(:typetalk_user, %{id: "not-found-id"})

    assert Ueberauth.Strategy.Typetalk.uid(conn) == nil
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

  describe "extra" do
  end
end
