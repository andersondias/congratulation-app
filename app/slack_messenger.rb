require 'httpclient'

class SlackMessenger
  SLACK_API_ENDPOINT = 'https://slack.com/api/chat.postMessage'.freeze

  def self.deliver(from, to, message)
    new(from, to, message).deliver
  end

  def initialize(from, to, message)
    @from = from
    @to = to
    @message = message
  end

  def deliver
    client = HTTPClient.new
    client.post(SLACK_API_ENDPOINT, params)
  end

  def params
    {
      token: ENV['SLACK_OAUTH'],
      channel: @to,
      text: "@#{@from} has congratulated you: \"#{@message}\".",
      as_user: false,
      link_names: true
    }
  end
end
