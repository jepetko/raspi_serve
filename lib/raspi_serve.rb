require "rack"
require "rack/handler/puma"
require "warden"
require "raspi_serve/version"
require "raspi_serve/api_key_warden_strategy"

module RaspiServe
end


# usage:
# curl localhost:9292
# curl localhost:9292 -H "API_KEY:123"
app = Rack::Builder.app do

  RaspiServe::ApiKeyWardenStrategy.register_on_warden

  use Warden::Manager do |manager|
    manager.failure_app = proc { [401, {'Content-Type' => 'text/html'}, ['Not Authorized']] }
    manager.default_strategies RaspiServe::ApiKeyWardenStrategy.identifier
  end

  run proc { |env|
    env['warden'].authenticate!
    proc { [200, { 'Content-Type' => 'plain/text' }, ['Hello world']] }.call env
  }
end

Rack::Handler::Puma.run app, Port: 9292