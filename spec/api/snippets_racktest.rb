require 'rack/test'
require 'test/unit'
require 'rspec'
require 'fabrication'
require 'pry'
require 'raspi_serve'
require_relative '../fabricators/snippet_fabricator'

module RaspiServe
  class SnippetsTest < Test::Unit::TestCase
    include Rack::Test::Methods
    include RSpec::Matchers

    def app
      RaspiServe.create_rack_app
    end

    def before_setup
      Snippet.clear
    end

    def test_list_snippets
      3.times { Fabricate(:snippet) }
      header 'API_KEY', '123'
      get '/snippets'
      arr = JSON.parse last_response.body
      expect(arr.count).to be 3
      expect(arr.first['id']).to match /^[a-z0-9]+$/
    end

    def test_list_snippets_when_api_key_missing
      3.times { Fabricate(:snippet) }
      get '/snippets'
      expect(last_response.body).to include 'Not Authorized'
    end

    def test_create_snippet
      header 'API_KEY', '123'
      post '/snippets', {code: %q[puts 'hello']}.to_json
      expect(last_response.status).to eq 200

      last_snippet_id = Snippet.recent(1).first.id
      get "/snippets/#{last_snippet_id}"
      snippet = JSON.parse(last_response.body)
      expect(snippet['code']).to eq %q[puts 'hello']
    end

    def test_update_snippet
      header 'API_KEY', '123'
      snippet = Fabricate(:snippet, {code: %q[puts 'before']})
      post "snippets/#{snippet.id}", {code: %q[puts 'after']}.to_json

      get "/snippets/#{snippet.id}"
      snippet = JSON.parse(last_response.body)
      expect(snippet['code']).to eq %q[puts 'after']
    end
  end
end