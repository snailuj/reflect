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
alias Reflect.Accounts.User
alias Reflect.Courses.Course
alias Reflect.Courses.Membership
alias Reflect.Journals
alias Reflect.Journals.Journal
alias Reflect.Journals.Entry
alias Reflect.Reflections.Prompt
alias Reflect.Reflections.Reflection

courses = from(c in Course, where: c.name == "Mindfulness for Inner Peace") |> Repo.all()
mindfulness_for_inner_peace = Enum.at(courses, 0)

# enrol non-admin students in mindfulness course
students = from(u in User, where: not u.is_admin) |> Repo.all()

memberships =
  Enum.map(students, fn student ->
    Repo.insert!(%Membership{
      user: student,
      course: mindfulness_for_inner_peace
    })
  end)

journal =
  Repo.insert!(%Journal{
    name: "Journal",
    tags: "sila, paramita, 30 day",
    course_id: mindfulness_for_inner_peace.id
  })

titles =
  [
    {1, "Being Aware, Contentment and Generosity"},
    {2, "Generosity"},
    {3, "Our Unconscious Patterns of Mind"},
    {4, "Our Unconscious Patterns of Mind"},
    {5, "Our Unconscious Assumptions"},
    {6, "Our Unconscious Assumptions"},
    {7, "The Practice of Generosity"},
    {8, "Non-harm"},
    {9, "Non-harm"},
    {10, "Our Speech"},
    {11, "Our Speech"},
    {12, "Midway Review"},
    {13, "Generosity and non-harm in our thoughts, speech and actions"},
    {14, "Generosity and non-harm in our thoughts, speech and actions"},
    {15, "The Joy of Letting Go"},
    {16, "The Joy of Letting Go"},
    {17, "Diligence"},
    {18, "Diligence"},
    {19, "Patience"},
    {20, "Patience"},
    {21, "Letting go of craving happily, diligently and patiently"},
    {22, "Staying on Course"},
    {23, "Staying on Course"},
    {24, "Loving-kindness"},
    {25, "Loving-kindness"},
    {26, "Equanimity and serenity"},
    {27, "Equanimity and serenity"},
    {28, "Reflections on cultivating these essential qualities"}
  ]
  |> Enum.sort(fn {i1, _}, {i2, _} -> i1 < i2 end)

entrys =
  Enum.map(titles, fn {index, title} ->
    {:ok, local_now} =
      DateTime.now("Pacific/Auckland")

    {:ok, naive} = local_now
      |> DateTime.to_date()
      |> Date.add(-4) # start course 4 days ago
      |> Date.add(index)
      |> NaiveDateTime.new(~T[00:00:00])

    occurs = DateTime.from_naive!(naive, "Etc/UTC")

    Repo.insert!(%Entry{
      title: title,
      order: index,
      occurs: occurs,
      tags: "paramita",
      journal_id: journal.id
    })
  end)

entrys = Enum.sort(entrys, fn e1, e2 -> e1.occurs < e2.occurs end) |> Enum.zip(1..28)

Enum.map(entrys, fn {entry, index} ->
  Repo.insert!(%Prompt{
    order: 1,
    label: "Did you find today’s talk useful?",
    description: "",
    type: ~s({"type": "five_heart"}),
    tags: "",
    entry_id: entry.id
  })
end)

Enum.map(entrys, fn {entry, index} ->
  Repo.insert!(%Prompt{
    order: 2,
    label: "Did you explore the topic of the talk during your day?",
    description: "",
    type: ~S"""
      {"type": "options",
       "options": [
          {"label": "Yes",      "value": 1},
          {"label": "No",       "value": 2},
          {"label": "A Little", "value": 3}]}
    """,
    tags: "",
    entry_id: entry.id
  })
end)

Enum.map(entrys, fn {entry, index} ->
  Repo.insert!(%Prompt{
    order: 3,
    label: "Did you have a walk today?",
    description: "",
    type: ~S"""
      {"type": "options",
       "options": [
        {"label": "Yes", "value": 1},
        {"label": "No",  "value": 2}]}
    """,
    tags: "",
    entry_id: entry.id
  })
end)

Enum.map(entrys, fn {entry, index} ->
  Repo.insert!(%Prompt{
    order: 4,
    label: "How did you feel at the start of the day?",
    description: "",
    type: ~s({"type": "five_heart"}),
    tags: "",
    entry_id: entry.id
  })
end)

Enum.map(entrys, fn {entry, index} ->
  Repo.insert!(%Prompt{
    order: 5,
    label: "How do you feel at the end of the day?",
    description: "",
    type: ~s({"type": "five_heart"}),
    tags: "",
    entry_id: entry.id
  })
end)

Enum.map(entrys, fn {entry, index} ->
  Repo.insert!(%Prompt{
    order: 6,
    label: "Please feel free to write any personal reflections for your own reference",
    description: "This is exclusively your own journal and will not be read by anyone else.",
    type: ~s({"type": "textarea"}),
    tags: "",
    entry_id: entry.id
  })
end)

students
|> Enum.map(fn student ->
  journal = Journals.load_full_journal(journal.id, student)
  journal.entrys
  |> Enum.take(4)
  |> Enum.map(fn entry ->
    entry |> IO.inspect()
    entry.prompts
    |> Enum.map(fn prompt ->
        definition = Jason.decode!(prompt.type)
        value = case definition["type"] do
          "five_heart" -> Integer.to_string(:rand.uniform(5))

          "options" -> Integer.to_string(:rand.uniform(2))

          "textarea" -> "Lorem ipsum dolor sit amet"
        end

        Repo.insert!(%Reflection{
          value: value,
          user: student,
          prompt: prompt
        })
      end)
  end)
end)
