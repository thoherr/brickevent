# Be sure to restart your server when you modify this file.

# explicit expiration avoids session to be cleared on browser closing, see
# https://stackoverflow.com/a/77865002
Rails.application.config.session_store :cookie_store, key: '_brickevent', expire_after: 14.days
