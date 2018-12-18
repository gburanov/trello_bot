require_relative 'validation'

class NoReviewsValidation < PrValidation
  def failed?
    pr.reviews.count == 0
  end

  def notify
    text = "#{pr.url} has no reviewers for #{stale_time}. Who wanna review?"
    if pr.card.unapproved_ps.count == 1
      text += " That's the last one and ticket can be moved to approved!"
    end
    if pr.card.reviewers.count == 0
      notifier.message(text)
    else
      text += " Maybe #{suggested} can do it since he reviewed other PRs from that ticket"
      notifier.notify_person(slackuser_for(suggested), text)
    end
    return false
  end

  private

  def suggested
    pr.card.reviewers[0]
  end
end