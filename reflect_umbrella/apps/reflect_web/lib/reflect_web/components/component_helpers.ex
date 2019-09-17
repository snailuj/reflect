defmodule ReflectWeb.Components.ComponentHelpers do
  alias Phoenix.Naming
  alias ReflectWeb.Components

  @moduledoc """
  Conveniences for reusable UI components
  """

  def component(namespace, name, assigns \\ []) do
    c(namespace, template(name), assigns)
  end

  def component(namespace, name, assigns, opts) do
    c(namespace, template(name), assigns, opts)
  end

  @doc """
    Common namespace-less components
  """
  def common(name, assigns \\ []) do
    c(template(name), assigns)
  end

  def c(template, assigns) do
    apply(
      view(),
      :render,
      [template, assigns]
    )
  end

  def c(namespace, template, assigns) do
    apply(
      view(namespace),
      :render,
      [template, assigns]
    )
  end

  def c(namespace, template, assigns, do: block) do
    apply(
      view(namespace),
      :render,
      [template, Keyword.merge(assigns, do: block)]
    )
  end

  defp view do
    Components.CommonView
  end

  defp view(name) do
    module_name = Naming.camelize("#{name}") <> "View"
    Module.concat(Components, module_name)
  end

  defp template(name) when is_atom(name) do
    "#{name}.html"
  end
end
