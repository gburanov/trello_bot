require_relative '../mapper'

class PrValidation
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

  def stale_time
    days = (pr.time_diff / 1.day).round
    return "#{days} days" if days >= 1
    hours = (pr.time_diff / 1.hour).round
    return "#{hours} hours"
  end

  def slackuser_for(user)
    GitHubToSlackMaper.new(user).call
  end
end