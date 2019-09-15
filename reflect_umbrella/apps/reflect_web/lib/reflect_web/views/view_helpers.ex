defmodule ReflectWeb.ViewHelpers do
  import Phoenix.HTML

  alias Phoenix.HTML.Form
  alias ReflectWeb.ViewHelpers

  # todo gettext and i18n all the month names in here

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

  @months %{1 => "Jan", 2 => "Feb", 3 => "Mar", 4 => "Apr",
    5 => "May", 6 => "Jun", 7 => "Jul", 8 => "Aug", 9 => "Sep",
    10 => "Oct", 11 => "Nov", 12 => "Dec"
  }
  def date_render(%DateTime{} = datetime) do
    [datetime.day, @months[datetime.month], datetime.year]
    |> Enum.join(" ")
  end
end
