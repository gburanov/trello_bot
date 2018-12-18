require_relative 'validation'

class UnansweredCommentsValidation < PrValidation
  def failed?
    unanswered_comment || unanswered_review
  end

  def notify
    if unanswered_comment
      text = "#{pr.url} has unanswered comment #{last_reviewer_comment.html_url}"
    else
      text = "#{pr.url} has unanswered review #{last_review.html_url}"
    end
    notifier.notify_person(slackuser_for(pr.creator), text)
    return false
  end

  private

  def last_commit_time
    @last_commit_time ||= pr.commits[-1].commit.committer.date
  end

  def unanswered_review
    last_review.submitted_at > last_author_comment.created_at &&
      last_review.submitted_at > last_commit_time 
  end

  def unanswered_comment
    if last_author_comment  && last_author_comment.created_at > last_reviewer_comment.created_at
      return false
    end
    last_reviewer_comment.created_at > last_commit_time
  end

  def last_review
    pr.not_approved_reviews[-1]
  end

  def last_author_comment
    pr.comments.select{ |c| c.user.login == pr.creator }[-1]
  end

  def last_reviewer_comment
    pr.comments.select{ |c| c.user.login != pr.creator }[-1]
  end
end