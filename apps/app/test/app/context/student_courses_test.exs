defmodule App.Context.StudentCoursesTest do
  use App.DataCase

  alias App.Context.StudentCourses

  describe "student_courses" do
    alias App.Schema.StudentCourse

    import App.Context.StudentCoursesFixtures

    @invalid_attrs %{}

    test "list_student_courses/0 returns all student_courses" do
      student_course = student_course_fixture()
      assert StudentCourses.list_student_courses() == [student_course]
    end

    test "get_student_course!/1 returns the student_course with given id" do
      student_course = student_course_fixture()
      assert StudentCourses.get_student_course!(student_course.id) == student_course
    end

    test "create_student_course/1 with valid data creates a student_course" do
      valid_attrs = %{}

      assert {:ok, %StudentCourse{} = student_course} = StudentCourses.create_student_course(valid_attrs)
    end

    test "create_student_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StudentCourses.create_student_course(@invalid_attrs)
    end

    test "update_student_course/2 with valid data updates the student_course" do
      student_course = student_course_fixture()
      update_attrs = %{}

      assert {:ok, %StudentCourse{} = student_course} = StudentCourses.update_student_course(student_course, update_attrs)
    end

    test "update_student_course/2 with invalid data returns error changeset" do
      student_course = student_course_fixture()
      assert {:error, %Ecto.Changeset{}} = StudentCourses.update_student_course(student_course, @invalid_attrs)
      assert student_course == StudentCourses.get_student_course!(student_course.id)
    end

    test "delete_student_course/1 deletes the student_course" do
      student_course = student_course_fixture()
      assert {:ok, %StudentCourse{}} = StudentCourses.delete_student_course(student_course)
      assert_raise Ecto.NoResultsError, fn -> StudentCourses.get_student_course!(student_course.id) end
    end

    test "change_student_course/1 returns a student_course changeset" do
      student_course = student_course_fixture()
      assert %Ecto.Changeset{} = StudentCourses.change_student_course(student_course)
    end
  end
end
