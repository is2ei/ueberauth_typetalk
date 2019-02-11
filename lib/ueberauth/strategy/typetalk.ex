defmodule Ueberauth.Strategy.Typetalk do
  @moduledoc """
  Provides an Ueberauth strategy for authenticating with Typetalk.
  """

  use Ueberauth.Strategy,
    uid_field: :id,
    default_scope: "my",
    oauth2_module: Ueberauth.Strategy.Typetalk.OAuth

  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth.Credentials
  alias Ueberauth.Auth.Extra

  @doc """
  Handles the initial redirect to the typetalk authentication page.

  To customize the scope (permissions) that are requested by typetalk include them as part of your url:

      "/oauth2/authorize?scope=my topic.read topic.post"

  You can also include a `state` param that typetalk will return to you.
  """
  def handle_request!(conn) do
    scopes = conn.params["scope"] || option(conn, :default_scope)

    opts = [redirect_uri: callback_url(conn), scope: scopes]

    opts =
      if conn.params["state"], do: Keyword.put(opts, :state, conn.params["state"]), else: opts

    module = option(conn, :oauth2_module)
    redirect!(conn, apply(module, :authorize_url!, [opts]))
  end

  @doc """
  Handles the callback from Typetalk.
  """
  def handle_callback!(%Plug.Conn{params: %{"code" => code}} = conn) do
    module = option(conn, :oauth2_module)
    params = [code: code]

    opts = %{
      options: [
        client_options: [redirect_uri: callback_url(conn)]
      ]
    }

    token = apply(module, :get_token!, [params, opts])

    if token.access_token == nil do
      set_errors!(conn, [
        error(token.other_params["error"], token.other_params["error_description"])
      ])
    else
      fetch_user(conn, token)
    end
  end

  @doc false
  def handle_callback!(conn) do
    set_errors!(conn, [error("missing_code", "No code received")])
  end

  @doc """
  Cleans up the private area of the connection used for passing the raw Typetalk response around during the callback.
  """
  def handle_cleanup!(conn) do
    conn
    |> put_private(:typetalk_user, nil)
    |> put_private(:typetalk_token, nil)
  end

  @doc """
  Fetches the account id field fron the response.
  """
  def uid(conn) do
    uid_field =
      conn
      |> option(:uid_field)
      |> to_string

    conn.private.typetalk_user[uid_field]
  end

  @doc """
  Includes the credentials from the typetalk response.
  """
  def credentials(conn) do
    token = conn.private.typetalk_token
    scope_string = token.other_params["scope"] || ""
    scopes = String.split(scope_string, " ")

    %Credentials{
      token: token.access_token,
      refresh_token: token.refresh_token,
      expires_at: token.expires_at,
      expires: !!token.expires_at,
      token_type: Map.get(token, :token_type),
      scopes: scopes
    }
  end

  @doc """
  Fetches the fields to populate the info section of the `Ueberauth.Auth` struct.

  Typetalk API docs: https://developer.nulab-inc.com/docs/typetalk/api/1/get-profile/
  """
  def info(conn) do
    user = conn.private.typetalk_user

    %Info{
      name: user["fullName"],
      nickname: user["name"],
      email: user["mailAddress"],
      image: user["imageUrl"]
    }
  end

  @doc """
  Stores the raw information (including the token) obtained from the typetalk callback.
  """
  def extra(conn) do
    %Extra{
      raw_info: %{
        token: conn.private.typetalk_token,
        user: conn.private.typetalk_user
      }
    }
  end

  defp fetch_user(conn, token) do
    conn = put_private(conn, :typetalk_user, token)
  end

  defp with_param(opts, key, conn) do
    if value = conn.params[to_string(key)], do: Keyword.put(opts, key, value), else: opts
  end

  defp with_optional(opts, key, conn) do
    if option(conn, key), do: Keyword.put(opts, key, option(conn, key)), else: opts
  end

  defp option(conn, key) do
    Keyword.get(options(conn), key, Keyword.get(default_options(), key))
  end
end
