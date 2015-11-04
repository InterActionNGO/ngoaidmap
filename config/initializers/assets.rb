# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# Rails.application.config.assets.precompile += %w( application/main.js )
Rails.application.config.assets.precompile += %w( main.css )
Rails.application.config.assets.precompile += %w( report.css )
Rails.application.config.assets.precompile += %w( embed.css )
Rails.application.config.assets.precompile += %w( modernizr/modernizr.custom.js )
Rails.application.config.assets.precompile += %w( jquery-ui/css/no-theme/jquery-ui-1.10.4.custom.css )

Rails.application.config.assets.precompile += %w( application.js )
Rails.application.config.assets.precompile += %w( report.js )
