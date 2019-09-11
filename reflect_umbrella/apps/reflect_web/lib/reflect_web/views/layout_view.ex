defmodule ReflectWeb.LayoutView do
  use ReflectWeb, :view

  def first_name(user) do
    user.name
    |> String.split(" ")
    |> Enum.at(0)
  end

  def second_name(user) do
    user.name
    |> String.split(" ")
    |> Enum.at(1)
  end
end
