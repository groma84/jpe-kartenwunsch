npm run deploy --prefix ./assets
mix phx.digest
MIX_ENV=prod mix distillery.release