# make sure to set follwing environment variables:
# SECRET_KEY_BASE, HOST, PORT
# (Hint: You can generate a secret via 'mix phx.gen.secret')

# live with shell
#PORT=$PORT MIX_ENV=prod iex -S mix phx.server

# detached in the background
PORT=$PORT MIX_ENV=prod elixir --sname deploy_dashboard --detached -S mix phx.server
