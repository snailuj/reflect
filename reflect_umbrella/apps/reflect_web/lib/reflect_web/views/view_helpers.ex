defmodule ReflectWeb.ViewHelpers do
  import Phoenix.HTML

  alias Phoenix.HTML.Form
  alias ReflectWeb.ViewHelpers

  def date_select(form, field, opts \\ []) do
    Form.date_select(form, field, [builder: &ViewHelpers.date_builder/2] ++ opts)
  end

  def datetime_select(form, field, opts \\ []) do
    Form.datetime_select(form, field, [builder: &ViewHelpers.datetime_builder/1] ++ opts)
  end

  def date_builder(builder, date_label \\ "") do
    ~e"""
      <%= date_label %> <%= builder.(:day, []) %> <%= builder.(:month, []) %> <%= builder.(:year, []) %>
    """
  end

  def datetime_builder(builder) do
    date_e = date_builder(builder, "Date: ")
    time_e = ~e"""
        Time: <%= builder.(:hour, []) %> : <%= builder.(:minute, []) %>
      """

    [date_e|time_e]
  end
end
