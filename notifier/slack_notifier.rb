SLACK_CHANNEL = 'pr_testing'

require 'slack-ruby-client'

class SlackNotifier
  attr_reader :client
  attr_reader :map_ids

  def initialize
    @map_ids = {}
    @client = ::Slack::Web::Client.new(token: ENV['SLACK_TOKEN'])
  end

  def message(text)
    puts text
    client.chat_postMessage(channel: SLACK_CHANNEL, text: text)
  end

  def notify_person(person, text)
    id = slack_id(person)
    text = "Hey #{person}, #{text}"
    message(text)
  end

  def slack_id(person)
    return map_ids[person] if map_ids.key?(person)
    id = client.users_info(user: person).user.id
    map_ids[person] = id
    id
  rescue 
    raise "Unable to find user #{person}"
  end
end