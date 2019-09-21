defmodule ReflectWeb.Reflect.JournalView do
  use ReflectWeb, :view

  alias Reflect.Reflections.Prompt
  alias Reflect.Reflections.Reflection

  def parse_prompt_type(%Prompt{} = prompt) do
    prompt.type |> Jason.decode!() |> Map.get("type")
  end

  def render_reflection(%Prompt{} = prompt, %Reflection{} = reflection) do
    definition = prompt.type |> Jason.decode!()
    case definition["type"] do
      "five_heart" -> Enum.map(1..5, fn i ->
          if i <= String.to_integer(reflection.value) do
            "💚"
          else
            "♡"
          end
      end)

      "options" ->
        chosen = definition["options"]
        |> Enum.find(fn option -> option["value"] == String.to_integer(reflection.value) end)

        chosen["label"]

      "textarea" ->
        reflection.value
    end
  end
end
