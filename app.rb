require 'sinatra'

require_relative 'app/slack_authorizer'
require_relative 'app/slack_messenger'

use SlackAuthorizer

VALID_CONGRATULATE_EXPRESSION = /^(@[\w\.\-_]+) (.+)/

HELP_RESPONSE = 'Use `/congratulate` to send a congratulation message to '\
                'someone. Example: `/congratulate @anderson for design the '\
                'new API`'.freeze

OK_RESPONSE = "Thanks for sending this! I'll share it with %s.".freeze

INVALID_RESPONSE = 'Sorry, I didn’t quite get that. Perhaps try the words in a'\
                   ' different order? This usually works: '\
                   '`/congratulate [@someone] [message]`.'.freeze

post '/slack/command' do
  case params['text'].to_s.strip
  when 'help', '' then HELP_RESPONSE
  when VALID_CONGRATULATE_EXPRESSION
    from, message = $1, $2
    SlackMessenger.deliver(params['user_name'], from, message)
    OK_RESPONSE % from
  else INVALID_RESPONSE
  end
end
