require_relative 'validation'

class NoReviewsValidation < Validation
  def failed?
    pr.reviews.count == 0
  end

  def notify
    text = "#{pr.url} has no reviewers for #{stale_time}. Who wanna review?"
    notifier.message(text)
    return false
  end
end