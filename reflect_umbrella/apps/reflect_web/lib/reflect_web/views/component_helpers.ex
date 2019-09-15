defmodule ReflectWeb.ComponentHelpers do
  def component(template, assigns) do
    ReflectWeb.ComponentView.render(template, assigns)
  end

  def component(template, assigns, do: block) do
    ReflectWeb.ComponentView.render(template, Keyword.merge(assigns, do: block))
  end
end
