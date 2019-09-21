defmodule ReflectWeb.CourseController do
  use ReflectWeb, :controller

  alias Reflect.Courses

  def courses_for_user(conn, %{"user_id" => user_id}) do

    # query for courses, then render non-admin version of "index.html"
    conn
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    course = Courses.get_course!(id)

    conn
    |> render("show.html", course: course)
  end
end
