defmodule AppWeb.Utils.ClientHelper do
  alias AppWeb.Utils.Client

  def get_user_face(user_id, user_name) do
    Client.get_user_face(user_id, user_name)
  end

  def train_model() do
    Client.train_model()
  end

  def recognize_faces() do
    Client.recognize_faces()
  end

end