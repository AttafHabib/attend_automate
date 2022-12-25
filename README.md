# Attendance Automation using Image Recognition

For demo vist:
  https://attend-automate.attaf.tech/

To start the application, you need to run both Phoenix and Flask servers

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Run seeds with `mix run apps/app/priv/repo/seeds.exs`
  * Get enviroment variables with `source .env`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  
To start your Flask server:
  
  `$ flask --app client.py run` inside the attend_py directory


Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
