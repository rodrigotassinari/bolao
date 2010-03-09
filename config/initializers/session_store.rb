# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bolao_session',
  :secret      => 'c295b1a90bcc25d9b4ddeb6edc64d088ff1fb1aa9d9e9d8dccb060076d6db1e16fd339eb463c94020d5fefee84c9f94689cd6086245fd1320fca9f5eb408f0b5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
