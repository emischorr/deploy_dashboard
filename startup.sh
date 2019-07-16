# make sure to set follwing environment variables:
# SECRET_KEY_BASE, HOST, PORT
# (Hint: You can generate a secret via 'mix phx.gen.secret')

mix deps.get --only prod
MIX_ENV=prod mix compile

npm run deploy --prefix ./assets
mix phx.digest

PORT=$PORT MIX_ENV=prod mix phx.server
