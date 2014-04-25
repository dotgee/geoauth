# Be sure to restart your server when you modify this file.

### Geoauth::Application.config.session_store :cookie_store, key: '_geoauth_session'
Geoauth::Application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 10.minutes

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Geoauth::Application.config.session_store :active_record_store
