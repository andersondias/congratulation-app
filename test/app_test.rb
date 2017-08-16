ENV['RACK_ENV'] = 'test'

require './app'

require 'test/unit'
require 'rack/test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    ENV['SLACK_TOKEN'] = '123'
    ENV['SLACK_OAUTH'] = '321'
  end

  def teardown
    ENV['SLACK_TOKEN'] = nil
  end

  def test_it_returns_200_if_no_token_is_given
    post '/slack/command'
    assert_equal 200, last_response.status
    assert_equal SlackAuthorizer::UNAUTHORIZED_MESSAGE, last_response.body
  end

  def test_it_returns_200_if_no_token_does_not_matches
    post '/slack/command', token: '321'

    assert_equal 200, last_response.status
    assert_equal SlackAuthorizer::UNAUTHORIZED_MESSAGE, last_response.body
  end

  def test_it_returns_200_if_action_is_help
    post '/slack/command', token: '123',
                           command: '/congratulate',
                           text: 'help',
                           user_name: 'matz'

    assert_equal 200, last_response.status
    assert_equal HELP_RESPONSE, last_response.body
  end

  def test_it_returns_200_if_action_is_empty
    post '/slack/command', token: '123',
                           command: '/congratulate',
                           text: '',
                           user_name: 'matz'

    assert_equal 200, last_response.status
    assert_equal HELP_RESPONSE, last_response.body
  end

  def test_it_returns_200_with_success_message_if_valid
    post '/slack/command', token: '123',
                           command: '/congratulation',
                           text: '@anderson for delivering this api!',
                           user_name: 'matz'

    assert_equal 200, last_response.status

    success_message = "Thanks for sending this! I'll share it with @anderson."
    assert_equal success_message, last_response.body
  end

  def test_it_returns_200_with_text_sample_if_missing_to
    post '/slack/command', token: '123',
                           command: '/congratulation',
                           text: 'for delivering this api!',
                           user_name: 'matz'

    assert_equal 200, last_response.status
    assert_equal INVALID_RESPONSE, last_response.body
  end

  def test_it_returns_200_with_text_sample_if_missing_message
    post '/slack/command', token: '123',
                           command: '/congratulation',
                           text: '@anderson',
                           user_name: 'matz'

    assert_equal 200, last_response.status
    assert_equal INVALID_RESPONSE, last_response.body
  end
end
