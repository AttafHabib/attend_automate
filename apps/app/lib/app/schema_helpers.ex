defmodule App.SchemaHelpers do


  @spec custom_error(%Ecto.Changeset{})::%Ecto.Changeset{}
  defp custom_error(%Ecto.Changeset{}=changeset) do
    update_in(changeset.errors, &(Enum.map &1, fn
      {key_, {"can't be blank",validations}} -> {key_,{"#{key_ |>Atom.to_string|>String.capitalize} can't be blank", validations}}
      {key_, {message, validations}} -> {key_,{"#{key_ |>Atom.to_string|>String.capitalize}"<>message,validations}}
      {key_, val} -> {key_,val}
    end))
  end
end