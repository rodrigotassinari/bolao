# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bolao_session',
  :secret      => '26d4e8f55a6ffe9f15ae93cf733cb7cc32f26ea9833d2427361ad7898df4ce05a6cc468e702fa836daa8700955a232a7d032b5b0a750b7ecd356c9bd104c9028'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
