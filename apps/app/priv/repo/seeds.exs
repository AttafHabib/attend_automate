# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     App.Repo.insert!(%App.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
{:ok, user} = App.Repo.insert(%App.Schema.User{
  email: "admin@admin.com",
  password: Argon2.hash_pwd_salt("admin"),
  username: "Admin"
})
{:ok, role1} = App.Repo.insert(%App.Schema.Role{name: "admin"})
{:ok, role2} = App.Repo.insert(%App.Schema.Role{name: "student"})
{:ok, role3} = App.Repo.insert(%App.Schema.Role{name: "teacher"})
{:ok, role4} = App.Repo.insert(%App.Schema.Role{name: "hod"})


{:ok, _user_role} = App.Repo.insert(%App.Schema.UserRole{
  user_id: user.id,
  role_id: role1.id
})

{:ok, student1} = App.Repo.insert(%App.Schema.Student{
  first_name: "Attaf",
  last_name: "Habib",
  email: "attufhabib@gmail.com",
  cnic: "3630212345678",
  roll_no: "0132",
  address: "House XYZ Lahore Punjab Pakistan",
  phone_no: "03001234567"
})

{:ok, user} = App.Repo.insert(%App.Schema.User{
  email: "attufhabib@gmail.com",
  password: Argon2.hash_pwd_salt("admin"),
  username: "Attaf"
})

{:ok, _user_role} = App.Repo.insert(%App.Schema.UserRole{
  user_id: user.id,
  role_id: role2.id
})

{:ok, dpt} = App.Repo.insert(%App.Schema.Department{
  name: "ComputerScience",
  dpt_code: "CS",
})

student1 = App.Schema.Student.changeset(student1, %{user_id: user.id, department_id: dpt.id})
{:ok, student1} = App.Repo.update(student1)
