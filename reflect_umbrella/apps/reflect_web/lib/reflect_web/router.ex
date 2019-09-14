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

    resources "/users", UserController, only: [:new, :create, :edit, :update, :show]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/courses/user/:user_id", CourseController, :courses_for_user
    resources "/courses", CourseController, only: [:show]
  end

  scope "/admin", ReflectWeb.Admin, as: :admin do
    pipe_through [:browser, :is_admin]

    resources "/users", UserController
    resources "/courses", CourseController
    resources "/membership", MembershipController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ReflectWeb do
  #   pipe_through :api
  # end
end
