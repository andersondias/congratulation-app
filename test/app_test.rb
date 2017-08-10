ENV['RACK_ENV'] = 'test'

require './app'

require 'test/unit'
require 'rack/test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_returns_200
    post '/slack/command'
    assert_equal 200, last_response.status
    assert_equal 'OK', last_response.body
  end
end
