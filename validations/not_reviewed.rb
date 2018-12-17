require 'active_support/core_ext/numeric/time'

require_relative 'validation'

class NotReviewedValidation < Validation
  def failed?
    pr.time_diff > 3.hours
  end

  def notify
    text = "#{pr.url} is stale for #{stale_time}! Please take a look"
    pr.not_approved_reviewers.map do |reviewer|
      notifier.notify_person(slackuser_for(reviewer), text)
    end
    return false
  end
end
