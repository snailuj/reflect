defmodule Reflect.ReflectionsTest do
  use Reflect.DataCase

  alias Reflect.Reflections

  describe "prompts" do
    alias Reflect.Reflections.Prompt

    @valid_attrs %{description: "some description", label: "some label", order: 42, tags: "some tags", type: "some type"}
    @update_attrs %{description: "some updated description", label: "some updated label", order: 43, tags: "some updated tags", type: "some updated type"}
    @invalid_attrs %{description: nil, label: nil, order: nil, tags: nil, type: nil}

    def prompt_fixture(attrs \\ %{}) do
      {:ok, prompt} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reflections.create_prompt()

      prompt
    end

    test "list_prompts/0 returns all prompts" do
      prompt = prompt_fixture()
      assert Reflections.list_prompts() == [prompt]
    end

    test "get_prompt!/1 returns the prompt with given id" do
      prompt = prompt_fixture()
      assert Reflections.get_prompt!(prompt.id) == prompt
    end

    test "create_prompt/1 with valid data creates a prompt" do
      assert {:ok, %Prompt{} = prompt} = Reflections.create_prompt(@valid_attrs)
      assert prompt.description == "some description"
      assert prompt.label == "some label"
      assert prompt.order == 42
      assert prompt.tags == "some tags"
      assert prompt.type == "some type"
    end

    test "create_prompt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reflections.create_prompt(@invalid_attrs)
    end

    test "update_prompt/2 with valid data updates the prompt" do
      prompt = prompt_fixture()
      assert {:ok, %Prompt{} = prompt} = Reflections.update_prompt(prompt, @update_attrs)
      assert prompt.description == "some updated description"
      assert prompt.label == "some updated label"
      assert prompt.order == 43
      assert prompt.tags == "some updated tags"
      assert prompt.type == "some updated type"
    end

    test "update_prompt/2 with invalid data returns error changeset" do
      prompt = prompt_fixture()
      assert {:error, %Ecto.Changeset{}} = Reflections.update_prompt(prompt, @invalid_attrs)
      assert prompt == Reflections.get_prompt!(prompt.id)
    end

    test "delete_prompt/1 deletes the prompt" do
      prompt = prompt_fixture()
      assert {:ok, %Prompt{}} = Reflections.delete_prompt(prompt)
      assert_raise Ecto.NoResultsError, fn -> Reflections.get_prompt!(prompt.id) end
    end

    test "change_prompt/1 returns a prompt changeset" do
      prompt = prompt_fixture()
      assert %Ecto.Changeset{} = Reflections.change_prompt(prompt)
    end
  end

  describe "reflections" do
    alias Reflect.Reflections.Reflection

    @valid_attrs %{value: "some value"}
    @update_attrs %{value: "some updated value"}
    @invalid_attrs %{value: nil}

    def reflection_fixture(attrs \\ %{}) do
      {:ok, reflection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reflections.create_reflection()

      reflection
    end

    test "list_reflections/0 returns all reflections" do
      reflection = reflection_fixture()
      assert Reflections.list_reflections() == [reflection]
    end

    test "get_reflection!/1 returns the reflection with given id" do
      reflection = reflection_fixture()
      assert Reflections.get_reflection!(reflection.id) == reflection
    end

    test "create_reflection/1 with valid data creates a reflection" do
      assert {:ok, %Reflection{} = reflection} = Reflections.create_reflection(@valid_attrs)
      assert reflection.value == "some value"
    end

    test "create_reflection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reflections.create_reflection(@invalid_attrs)
    end

    test "update_reflection/2 with valid data updates the reflection" do
      reflection = reflection_fixture()
      assert {:ok, %Reflection{} = reflection} = Reflections.update_reflection(reflection, @update_attrs)
      assert reflection.value == "some updated value"
    end

    test "update_reflection/2 with invalid data returns error changeset" do
      reflection = reflection_fixture()
      assert {:error, %Ecto.Changeset{}} = Reflections.update_reflection(reflection, @invalid_attrs)
      assert reflection == Reflections.get_reflection!(reflection.id)
    end

    test "delete_reflection/1 deletes the reflection" do
      reflection = reflection_fixture()
      assert {:ok, %Reflection{}} = Reflections.delete_reflection(reflection)
      assert_raise Ecto.NoResultsError, fn -> Reflections.get_reflection!(reflection.id) end
    end

    test "change_reflection/1 returns a reflection changeset" do
      reflection = reflection_fixture()
      assert %Ecto.Changeset{} = Reflections.change_reflection(reflection)
    end
  end
end
