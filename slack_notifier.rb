SLACK_CHANNEL = 'pr_testing'

require 'slack-ruby-client'

class SlackNotifier
  attr_reader :client

  def initialize
    @client = ::Slack::Web::Client.new(token: ENV['SLACK_TOKEN'])
  end

  def message(text)
    puts text
    client.chat_postMessage(channel: SLACK_CHANNEL, text: text)
  end
end