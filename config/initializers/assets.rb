# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Add app/javascript to asset paths so importmap can serve files
Rails.application.config.assets.paths << Rails.root.join("app/javascript")

# Precompile importmap JavaScript files as raw copies (not processed by Sprockets)
# These files contain ES6 imports which Sprockets can't handle
Rails.application.config.assets.precompile += %w[
  application.js
  utils/app_info.js
  controllers/application.js
  controllers/index.js
  controllers/hello_controller.js
]
