# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.paths << File.join(Rails.root, 'app', 'assets', 'fonts')
Rails.application.config.assets.paths << File.join(Rails.root, 'lib', 'assets')
Rails.application.config.assets.paths << File.join(Rails.root, 'public', 'app', 'vendor')

# Require JS configuration
Rails.application.config.requirejs.logical_path_patterns += [/\.handlebars$/]
Rails.application.config.requirejs.logical_path_patterns += [/\.svg$/]

# Precompile additional assets
# Explicitly register the extensions we are interested in compiling
Rails.application.config.assets.precompile.push(Proc.new do |path|
  File.extname(path).in? [
    '.html', '.erb', '.haml', '.handlebars',  # Templates
    '.png',  '.gif', '.jpg', '.jpeg', '.svg', # Images
    '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
  ]
end)

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# Rails.application.config.assets.precompile += %w( application/main.js )
# Rails.application.config.assets.precompile += %w( fontawesome-webfont.woff2 embed.css )
Rails.application.config.assets.precompile += %w( main.css )
Rails.application.config.assets.precompile += %w( main-bootstrap.css )
Rails.application.config.assets.precompile += %w( report.css )
Rails.application.config.assets.precompile += %w( embed.css )
Rails.application.config.assets.precompile += %w( modernizr/modernizr.custom.js )
Rails.application.config.assets.precompile += %w( jquery-ui/css/no-theme/jquery-ui-1.10.4.custom.css )

Rails.application.config.assets.precompile += %w( backoffice.css )
Rails.application.config.assets.precompile += %w( backoffice/jscroll.css )
Rails.application.config.assets.precompile += %w( backoffice/chosen.css )
Rails.application.config.assets.precompile += %w( backoffice/plugins/fineuploader-3.3.0.css )
Rails.application.config.assets.precompile += %w( backoffice/jquery-ui-1.7.2.custom.css )
Rails.application.config.assets.precompile += %w( backoffice/layout.css )
Rails.application.config.assets.precompile += %w( backoffice/smbtc-layout.css )

Rails.application.config.assets.precompile += %w( application.js )
Rails.application.config.assets.precompile += %w( report.js explore.js data_quality.js)
