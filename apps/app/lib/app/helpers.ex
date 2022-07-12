defmodule App.Helpers do
  alias App.Guardian

  @spec update_error(%Ecto.Changeset{}, {atom, String.t()}):: %Ecto.Changeset{}
  def update_error(%Ecto.Changeset{} = changeset, {key, error}) do
    if(changeset.errors[key]) do
      update_in(changeset.errors, &Enum.map(&1, fn
        {key_ = ^key, {_, validations}} -> {key_, {error, validations}}
#        {key_, {message, validations}} -> {key_,{"#{key_ |>Atom.to_string|>String.capitalize}"<>message,validations}}
        {key_, val} -> {key_,val}
      end))
    else
      Ecto.Changeset.add_error(changeset, key, error)
    end
  end

  @spec add_error(%Ecto.Changeset{}, {atom, String.t()}):: %Ecto.Changeset{}
  def add_error(%Ecto.Changeset{} = changeset, {key, error}) do
    if(!changeset.errors[key]) do
      Ecto.Changeset.add_error(changeset, key, error)
    else
      changeset
    end
  end


  def get_current_user(token) do
    {:ok, claims} = Guardian.decode_and_verify(token)
    Guardian.resource_from_claims(claims)
  end

end