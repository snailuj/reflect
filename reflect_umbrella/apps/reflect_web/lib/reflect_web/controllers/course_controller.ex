defmodule ReflectWeb.CourseController do
  use ReflectWeb, :controller

  def courses_for_user(conn, %{"user_id" => user_id}) do

    # query for courses, then render non-admin version of "index.html"
    conn
  end

  def show(conn, %{"id" => id}) do
    conn
  end
end
