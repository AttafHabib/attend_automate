defmodule AppWeb.Utils.ClientHelper do
  alias AppWeb.Utils.Client

  def get_user_face(user_id) do
    Client.get_user_face(user_id)
  end

end