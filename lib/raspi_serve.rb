require "rack"
require "rack/handler/puma"
require "rack/cors"
require "warden"
require "json"

Dir[File.expand_path('**/*.rb', File.dirname(__FILE__))].each { |f| require f }

module RaspiServe

  def self.create_rack_app(&block)

    rack_app = Rack::Builder.new do
      ApiKeyWardenStrategy.register_on_warden

      use Rack::Cors do
        allow do
          origins '*'
          resource '*', :methods => [:get, :post]
        end
      end

      use Warden::Manager do |manager|
        manager.failure_app = proc { [401, {'Content-Type' => 'text/html'}, ['Not Authorized']] }
        manager.default_strategies ApiKeyWardenStrategy.identifier
      end

      map '/snippets' do
        run proc { |env|
          env['warden'].authenticate!
          [200, { 'Content-Type' => 'application/json' }, Snippet.all.to_json ]
        }
      end

      map '/' do
        run proc { |env|
          env['warden'].authenticate!
          [200, { 'Content-Type' => 'plain/text' }, ['Hello world']]
        }
      end
    end.to_app
    block.call(rack_app) if block_given?
    rack_app

  end

end