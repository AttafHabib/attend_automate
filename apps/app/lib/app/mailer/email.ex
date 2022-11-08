defmodule App.Mailer.Email do
  import Bamboo.Email


  @spec update_password_email(String.t(), String.t(), String.t(), String.t()) :: %Bamboo.Email{}
  def update_password_email(to, subject, html, body) do
    new_email(
      to: to,
      from: Application.get_env(:app, App.Mailer)[:username],
      subject: subject,
      html_body: html,
      text_body: body
    )
    |> put_header("Reply-To", Application.get_env(:app, App.Mailer)[:username])
    |> App.Mailer.deliver_now()
  end
end