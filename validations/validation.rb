require_relative '../mapper'

class Validation
  attr_reader :pr
  attr_reader :notifier

  def initialize(pr, notifier)
    @pr = pr
    @notifier = notifier
  end

  def call
    return true unless failed?
    notify
  end

  def stale_days
    (pr.time_diff / 1.day).round
  end

  def slackuser_for(user)
    GitHubToSlackMaper.new(user).call
  end
end