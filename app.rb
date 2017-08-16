require 'sinatra'

require_relative 'app/slack_authorizer'

use SlackAuthorizer

HELP_RESPONSE = 'Use `/congratulate` to send a congratulation message to '\
                'someone. Example:\n* `/congratulate @anderson for design the '\
                'new API`'.freeze

post '/slack/command' do
  HELP_RESPONSE
end
