defmodule Reflect.JournalsTest do
  use Reflect.DataCase

  alias Reflect.Journals

  describe "journals" do
    alias Reflect.Journals.Journal

    @valid_attrs %{name: "some name", tags: "some tags"}
    @update_attrs %{name: "some updated name", tags: "some updated tags"}
    @invalid_attrs %{name: nil, tags: nil}

    def journal_fixture(attrs \\ %{}) do
      {:ok, journal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Journals.create_journal()

      journal
    end

    test "list_journals/0 returns all journals" do
      journal = journal_fixture()
      assert Journals.list_journals() == [journal]
    end

    test "get_journal!/1 returns the journal with given id" do
      journal = journal_fixture()
      assert Journals.get_journal!(journal.id) == journal
    end

    test "create_journal/1 with valid data creates a journal" do
      assert {:ok, %Journal{} = journal} = Journals.create_journal(@valid_attrs)
      assert journal.name == "some name"
      assert journal.tags == "some tags"
    end

    test "create_journal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Journals.create_journal(@invalid_attrs)
    end

    test "update_journal/2 with valid data updates the journal" do
      journal = journal_fixture()
      assert {:ok, %Journal{} = journal} = Journals.update_journal(journal, @update_attrs)
      assert journal.name == "some updated name"
      assert journal.tags == "some updated tags"
    end

    test "update_journal/2 with invalid data returns error changeset" do
      journal = journal_fixture()
      assert {:error, %Ecto.Changeset{}} = Journals.update_journal(journal, @invalid_attrs)
      assert journal == Journals.get_journal!(journal.id)
    end

    test "delete_journal/1 deletes the journal" do
      journal = journal_fixture()
      assert {:ok, %Journal{}} = Journals.delete_journal(journal)
      assert_raise Ecto.NoResultsError, fn -> Journals.get_journal!(journal.id) end
    end

    test "change_journal/1 returns a journal changeset" do
      journal = journal_fixture()
      assert %Ecto.Changeset{} = Journals.change_journal(journal)
    end
  end

  describe "entrys" do
    alias Reflect.Journals.Entry

    @valid_attrs %{occurs: "2010-04-17T14:00:00Z", order: 42, tags: "some tags", title: "some title"}
    @update_attrs %{occurs: "2011-05-18T15:01:01Z", order: 43, tags: "some updated tags", title: "some updated title"}
    @invalid_attrs %{occurs: nil, order: nil, tags: nil, title: nil}

    def entry_fixture(attrs \\ %{}) do
      {:ok, entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Journals.create_entry()

      entry
    end

    test "list_entrys/0 returns all entrys" do
      entry = entry_fixture()
      assert Journals.list_entrys() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Journals.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      assert {:ok, %Entry{} = entry} = Journals.create_entry(@valid_attrs)
      assert entry.occurs == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert entry.order == 42
      assert entry.tags == "some tags"
      assert entry.title == "some title"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Journals.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{} = entry} = Journals.update_entry(entry, @update_attrs)
      assert entry.occurs == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert entry.order == 43
      assert entry.tags == "some updated tags"
      assert entry.title == "some updated title"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Journals.update_entry(entry, @invalid_attrs)
      assert entry == Journals.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Journals.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Journals.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Journals.change_entry(entry)
    end
  end
end
