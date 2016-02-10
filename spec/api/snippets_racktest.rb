require 'rack/test'
require 'test/unit'
require 'raspi_serve'
require 'pry'

class SnippetsTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    RaspiServe.create_rack_app
  end

  def test_list_snippets
    header 'API_KEY', '123'
    get '/snippets'
    assert last_response.body.include?('[]')
  end

end