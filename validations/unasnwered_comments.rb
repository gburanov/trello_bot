class UnansweredCommentsValidation
  def initialize(pr, notifier)
    @pr = pr
    @notifier = notifier
  end

  def call
    text = "#{pr.url} is stale for #{(pr.time_diff / 1.day).round} day(s)! Please take a look"
    slack_users = pr.not_approved_reviewers.map { |gu| GitHubToSlackMaper.new(gu).call }
    slack_users.each do |u|
      notifier.notify_person(u, text)
    end
  end
end