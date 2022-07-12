defmodule App.Context.StudentsTest do
  use App.DataCase

  alias App.Context.Students

  describe "students" do
    alias App.Schema.Student

    import App.Context.StudentsFixtures

    @invalid_attrs %{address: nil, cnic: nil, email: nil, first_name: nil, last_name: nil, phone_no: nil, roll_no: nil}

    test "list_students/0 returns all students" do
      student = student_fixture()
      assert Students.list_students() == [student]
    end

    test "get_student!/1 returns the student with given id" do
      student = student_fixture()
      assert Students.get_student!(student.id) == student
    end

    test "create_student/1 with valid data creates a student" do
      valid_attrs = %{address: "some address", cnic: "some cnic", email: "some email", first_name: "some first_name", last_name: "some last_name", phone_no: "some phone_no", roll_no: "some roll_no"}

      assert {:ok, %Student{} = student} = Students.create_student(valid_attrs)
      assert student.address == "some address"
      assert student.cnic == "some cnic"
      assert student.email == "some email"
      assert student.first_name == "some first_name"
      assert student.last_name == "some last_name"
      assert student.phone_no == "some phone_no"
      assert student.roll_no == "some roll_no"
    end

    test "create_student/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Students.create_student(@invalid_attrs)
    end

    test "update_student/2 with valid data updates the student" do
      student = student_fixture()
      update_attrs = %{address: "some updated address", cnic: "some updated cnic", email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", phone_no: "some updated phone_no", roll_no: "some updated roll_no"}

      assert {:ok, %Student{} = student} = Students.update_student(student, update_attrs)
      assert student.address == "some updated address"
      assert student.cnic == "some updated cnic"
      assert student.email == "some updated email"
      assert student.first_name == "some updated first_name"
      assert student.last_name == "some updated last_name"
      assert student.phone_no == "some updated phone_no"
      assert student.roll_no == "some updated roll_no"
    end

    test "update_student/2 with invalid data returns error changeset" do
      student = student_fixture()
      assert {:error, %Ecto.Changeset{}} = Students.update_student(student, @invalid_attrs)
      assert student == Students.get_student!(student.id)
    end

    test "delete_student/1 deletes the student" do
      student = student_fixture()
      assert {:ok, %Student{}} = Students.delete_student(student)
      assert_raise Ecto.NoResultsError, fn -> Students.get_student!(student.id) end
    end

    test "change_student/1 returns a student changeset" do
      student = student_fixture()
      assert %Ecto.Changeset{} = Students.change_student(student)
    end
  end
end
