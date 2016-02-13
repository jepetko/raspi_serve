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
          req = Rack::Request.new(env)
          body = ['']
          if req.request_method == 'POST'
            # POST /snippets
            Snippet.create(JSON.parse(req.body.read))
          elsif req.request_method == 'GET'
            # GET /snippets/{id}
            if id = req.path_info[1..-1]
              snippet = Snippet.where(id: id)
              body = [{code: snippet.first.code}.to_json]
            else
              body = Snippet.all.to_json
            end
          end
          [200, { 'Content-Type' => 'application/json' }, body]
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