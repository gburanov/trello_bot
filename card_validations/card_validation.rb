require_relative '../mapper'

class CardValidation
  attr_reader :card
  attr_reader :notifier

  def initialize(card, notifier)
    @card = card
    @notifier = notifier
  end

  def call
    return true unless failed?
    notify
  end

  def slackuser_for(user)
    GitHubToSlackMaper.new(user).call
  end
end