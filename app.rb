require_relative 'models'

require 'roda'
require 'tilt/sass'

class App < Roda
  plugin :default_headers,
    'Content-Type'=>'text/html',
    #'Strict-Transport-Security'=>'max-age=16070400;', # Uncomment if only allowing https:// access
    'X-Frame-Options'=>'deny',
    'X-Content-Type-Options'=>'nosniff',
    'X-XSS-Protection'=>'1; mode=block'

  plugin :content_security_policy do |csp|
    csp.default_src :none
    csp.style_src :self, 'https://maxcdn.bootstrapcdn.com'
    csp.form_action :self
    csp.script_src :self
    csp.connect_src :self
    csp.base_uri :none
    csp.frame_ancestors :none
  end

  plugin :route_csrf
  plugin :flash
  plugin :assets, css: 'app.scss', css_opts: {style: :compressed, cache: false}, timestamp_paths: true
  plugin :render, escape: true
  plugin :public
  plugin :multi_route

  # Don't delete session secrets from environment in development mode as it breaks reloading
  cipher_secret = ENV['RACK_ENV'] == 'development' ? ENV['APP_SESSION_CIPHER_SECRET'] : ENV.delete('APP_SESSION_CIPHER_SECRET')
  hmac_secret = ENV['RACK_ENV'] == 'development' ? ENV['APP_SESSION_HMAC_SECRET'] : ENV.delete('APP_SESSION_HMAC_SECRET')

  plugin :sessions,
    key: '_App.session',
    #cookie_options: {secure: ENV['RACK_ENV'] != 'test'}, # Uncomment if only allowing https:// access
    cipher_secret: cipher_secret,
    hmac_secret: hmac_secret

  Unreloader.require('routes'){}

  route do |r|
    r.public
    r.assets
    check_csrf!
    r.multi_route

    r.root do
      view 'index'
    end
  end
end
