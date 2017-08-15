# Rack middleware responsible for authorizing the Slack message via token.
#
# Slack App "Verification token" can be found in the section "App Credentials"
# at slack application page and it's sent in every command request.
#
# In order to validate it we will setup a new ENV var called SLACK_TOKEN and
# match it's value with the income request token param. If they don't match we
# return a 401 response to slack.
class SlackAuthorizer
  UNAUTHORIZED_MESSAGE = 'Ops! Looks like the application is not authorized! '\
                         'Please review the token configuration.'.freeze

  RESPONSE = ['200', {'Content-Type' => 'text'}, [UNAUTHORIZED_MESSAGE]]

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.params['token'] == ENV['SLACK_TOKEN']
      @app.call(env)
    else
      RESPONSE
    end
  end
end
