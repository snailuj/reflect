defmodule ReflectWeb.Router do
  use ReflectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ReflectWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ReflectWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ReflectWeb do
  #   pipe_through :api
  # end
end