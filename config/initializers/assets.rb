# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
#CSS
Rails.application.config.assets.precompile += %w(jquery.tagsinput.css pivot.min.css c3.min.css  lightbox2.css subtotal.min.css pivot_style.css handsontable.full.min.css)
#JS
Rails.application.config.assets.precompile += %w(smart_admin/* chat.js signature.js  lightbox2.js jquery.tagsinput.js form_builder/form-builder.min.js form_builder/form-render.min.js)

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
