require 'rails'
require 'rails/railtie'
require 'webpack/rails/helper'
require 'uri'

module Webpack
  # :nodoc:
  class Railtie < ::Rails::Railtie
    config.after_initialize do
      ActiveSupport.on_load(:action_view) do
        include Webpack::Rails::Helper
      end
    end

    config.webpack = ActiveSupport::OrderedOptions.new
    config.webpack.config_file = 'config/webpack.config.js'
    config.webpack.binary = 'node_modules/.bin/webpack'

    config.webpack.dev_server = ActiveSupport::OrderedOptions.new
    if ENV["WEBPACK_HOST"]
      uri = URI.parse(ENV["WEBPACK_HOST"])
      config.webpack.dev_server.host   = uri.host
      config.webpack.dev_server.port   = uri.port
      config.webpack.dev_server.scheme = uri.scheme
    else
      config.webpack.dev_server.host   = 'localhost'
      config.webpack.dev_server.port   = 3808
      config.webpack.dev_server.scheme = "http"
    end
    config.webpack.dev_server.binary = 'node_modules/.bin/webpack-dev-server'
    config.webpack.dev_server.enabled = !::Rails.env.production?

    config.webpack.output_dir = "public/webpack"
    config.webpack.public_path = "webpack"
    config.webpack.manifest_filename = "manifest.json"

    rake_tasks do
      load "tasks/webpack.rake"
    end
  end
end
