defmodule App.Context.TeachersTest do
  use App.DataCase

  alias App.Context.Teachers

  describe "teachers" do
    alias App.Schema.Teacher

    import App.Context.TeachersFixtures

    @invalid_attrs %{address: nil, cnic: nil, email: nil, first_name: nil, last_name: nil, phone_no: nil}

    test "list_teachers/0 returns all teachers" do
      teacher = teacher_fixture()
      assert Teachers.list_teachers() == [teacher]
    end

    test "get_teacher!/1 returns the teacher with given id" do
      teacher = teacher_fixture()
      assert Teachers.get_teacher!(teacher.id) == teacher
    end

    test "create_teacher/1 with valid data creates a teacher" do
      valid_attrs = %{address: "some address", cnic: "some cnic", email: "some email", first_name: "some first_name", last_name: "some last_name", phone_no: "some phone_no"}

      assert {:ok, %Teacher{} = teacher} = Teachers.create_teacher(valid_attrs)
      assert teacher.address == "some address"
      assert teacher.cnic == "some cnic"
      assert teacher.email == "some email"
      assert teacher.first_name == "some first_name"
      assert teacher.last_name == "some last_name"
      assert teacher.phone_no == "some phone_no"
    end

    test "create_teacher/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teachers.create_teacher(@invalid_attrs)
    end

    test "update_teacher/2 with valid data updates the teacher" do
      teacher = teacher_fixture()
      update_attrs = %{address: "some updated address", cnic: "some updated cnic", email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", phone_no: "some updated phone_no"}

      assert {:ok, %Teacher{} = teacher} = Teachers.update_teacher(teacher, update_attrs)
      assert teacher.address == "some updated address"
      assert teacher.cnic == "some updated cnic"
      assert teacher.email == "some updated email"
      assert teacher.first_name == "some updated first_name"
      assert teacher.last_name == "some updated last_name"
      assert teacher.phone_no == "some updated phone_no"
    end

    test "update_teacher/2 with invalid data returns error changeset" do
      teacher = teacher_fixture()
      assert {:error, %Ecto.Changeset{}} = Teachers.update_teacher(teacher, @invalid_attrs)
      assert teacher == Teachers.get_teacher!(teacher.id)
    end

    test "delete_teacher/1 deletes the teacher" do
      teacher = teacher_fixture()
      assert {:ok, %Teacher{}} = Teachers.delete_teacher(teacher)
      assert_raise Ecto.NoResultsError, fn -> Teachers.get_teacher!(teacher.id) end
    end

    test "change_teacher/1 returns a teacher changeset" do
      teacher = teacher_fixture()
      assert %Ecto.Changeset{} = Teachers.change_teacher(teacher)
    end
  end
end
