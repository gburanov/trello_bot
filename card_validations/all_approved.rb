require_relative 'card_validation'

class AllApprovedValidation < CardValidation
  def failed?
    card.unapproved_ps.count == 0
  end

  def notify
    text = "All prs of #{card.url} are approved. It should be moved to approved lane"
    notifier.notify_person(slackuser_for(card.creator), text)
    return false
  end
end