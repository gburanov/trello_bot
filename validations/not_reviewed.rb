require_relative 'validation'

class NotReviewedValidation < Validation
  def failed?
    pr.time_diff > 3.hours
  end

  def notify
    text = "#{pr.url} is stale for #{(pr.time_diff / 1.day).round} day(s)! Please take a look"
    pr.not_approved_reviewers.map do reviewer
      notifier.notify_person(slackuser_for(reviewer), text)
    end
    return false
  end
end
