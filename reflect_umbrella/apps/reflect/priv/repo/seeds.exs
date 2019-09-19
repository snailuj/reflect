# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Reflect.Repo.insert!(%Reflect.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Ecto.Query

alias Reflect.Repo
alias Reflect.Courses
alias Reflect.Courses.Course
alias Reflect.Journals
alias Reflect.Journals.Journal
alias Reflect.Reflections
alias Reflect.Reflections.Prompt

course = (from c in Course, where: c.name == "Mindfulness for Inner Peace") |> Repo.all
journal = Repo.insert!(%Journals.Journal{name: "Journal", tags: "sila, paramita, 30 day", course_id: course[:id]})

titles = [ "Being Aware, Contentment and Generosity",
  "Generosity",
  "Our Unconscious Patterns of Mind",
  "Our Unconscious Patterns of Mind",
  "Our Unconscious Assumptions",
  "Our Unconscious Assumptions",
  "The Practice of Generosity",
  "Non-harm",
  "Non-harm",
  "Our Speech",
  "Our Speech",
  "Midway Review",
  "Generosity and non-harm in our thoughts, speech and actions",
  "Generosity and non-harm in our thoughts, speech and actions",
  "The Joy of Letting Go",
  "The Joy of Letting Go",
  "Diligence",
  "Diligence",
  "Patience",
  "Patience",
  "Letting go of craving happily, diligently and patiently",
  "Staying on Course",
  "Staying on Course",
  "Loving-kindness",
  "Loving-kindness",
  "Equanimity and serenity",
  "Equanimity and serenity",
  "Reflections on cultivating these essential qualities" ]
  |> Enum.zip(1..28)
  |> Enum.sort(fn {_, i1}, {_, i2} -> i1 < i2 end)

entrys = Enum.map(titles, fn {title, index} ->
  {:ok, naive} = ~D[2019-09-26] |> Date.add(index) |> NaiveDateTime.new(~T[00:00:00])
  occurs = DateTime.from_naive!(naive, "Etc/UTC")

  Repo.insert!(%Journals.Entry{
    title: title,
    order: index,
    occurs: occurs,
    tags: "paramita",
    journal_id: journal.id
  })
end)

entrys = Enum.sort(entrys, fn e1, e2 -> e1.id < e2.id end ) |> Enum.zip(1..28)
Enum.map(entrys, fn {entry, index} ->
  Repo.insert!(%Reflections.Prompt{
    order: 1,
    label: "Did you find today’s talk useful?",
    description: "",
    type: "five_heart",
    tags: "",
    entry_id: entry.id
  })
end)

Enum.map(entrys, fn {entry, index} ->
  Repo.insert!(%Reflections.Prompt{
    order: 2,
    label: "Did you explore the topic of the talk during your day?",
    description: "",
    type: "{\"options\": ['Yes', 'No', 'A Little']}",
    tags: "",
    entry_id: entry.id
  })
end)

Enum.map(entrys, fn {entry, index} ->
  Repo.insert!(%Reflections.Prompt{
    order: 3,
    label: "Did you have a walk today?",
    description: "",
    type: "{\"options\": [{\"label\": 'Yes', \"value\": 1}, {\"label\": 'No', \"value\": 2}]}",
    tags: "",
    entry_id: entry.id
  })
end)

Enum.map(entrys, fn {entry, index} ->
  Repo.insert!(%Reflections.Prompt{
    order: 4,
    label: "How did you feel at the start of the day?",
    description: "",
    type: "five_heart",
    tags: "",
    entry_id: entry.id
  })
end)

Enum.map(entrys, fn {entry, index} ->
  Repo.insert!(%Reflections.Prompt{
    order: 5,
    label: "How do you feel at the end of the day?",
    description: "",
    type: "five_heart",
    tags: "",
    entry_id: entry.id
  })
end)

Enum.map(entrys, fn {entry, index} ->
  Repo.insert!(%Reflections.Prompt{
    order: 6,
    label: "Please feel free to write any personal reflections for your own reference",
    description: "This is exclusively your own journal and will not be read by anyone else.",
    type: "textarea",
    tags: "",
    entry_id: entry.id
  })
end)
