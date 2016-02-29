require "rack"
require "rack/handler/puma"
require "rack/cors"
require "warden"
require "json"

Dir[File.expand_path('**/*.rb', File.dirname(__FILE__))].each { |f| require f }

module RaspiServe

  Hash.class_eval do
    def normalize_hash
      delta_hash = {}
      each do |key,val|
        if key.is_a?(String)
          delete(key)
          delta_hash[key.to_sym] = val
        end
      end
      merge! delta_hash
    end
  end

  def self.create_rack_app(&block)

    rack_app = Rack::Builder.new do
      ApiKeyWardenStrategy.register_on_warden

      use Rack::Cors do
        allow do
          origins '*'
          resource '*', :headers => :any, :methods => [:get, :post, :options]
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
          body = {}.to_json

          case req.request_method
            when 'POST'
              # POST /snippets/{id}
              if id = req.path_info[1..-1]
                Snippet.update(JSON.parse(req.body.read).merge(id: id).normalize_hash)
              # POST /snippets
              else
                exec_obj = {}
                Snippet.create(JSON.parse(req.body.read).normalize_hash, exec_obj)
                body = exec_obj.to_json
              end

            when 'GET'
              # GET /snippets/{id}
              if id = req.path_info[1..-1]
                snippets = Snippet.where(id: id)
                body = snippets && !snippets.empty? ? {code: snippets.first.code}.to_json : {}.to_json
              # GET /snippets
              else
                body = Snippet.all.to_json
              end
          end
          [200, { 'Content-Type' => 'application/json' }, [body]]
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