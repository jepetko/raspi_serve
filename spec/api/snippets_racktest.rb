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

    def test_list_snippets
      Snippet.clear
      3.times { Fabricate(:snippet) }
      header 'API_KEY', '123'
      get '/snippets'
      arr = JSON.parse(last_response.body)
      expect(arr.count).to be 3
    end

    def test_list_snippets_when_api_key_missing
      Snippet.clear
      3.times { Fabricate(:snippet) }
      get '/snippets'
      expect(last_response.body).to include 'Not Authorized'
    end
  end
end