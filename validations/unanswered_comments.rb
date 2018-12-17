require_relative 'validation'

class UnansweredCommentsValidation < Validation
  def failed?
    byebug
    unanswered_comment || unanswered_review
  end

  def notify
    text = "#{pr.url} has unanswered comment"
    slack_users = pr.not_approved_reviewers.map { |gu| GitHubToSlackMaper.new(gu).call }
    slack_users.each do |u|
      notifier.notify_person(u, text)
    end
    return false
  end

  private

  def unanswered_review
    pr.reviews[-1].submitted_at > last_author_comment.created_at &&
      pr.reviews[-1].submitted_at > pr.last_commit_time &&
  end

  def unanswered_comment
    last_reviewer_comment.created_at > last_author_comment.created_at &&
      last_reviewer_comment.created_at > pr.last_commit_time
  end

  def last_author_comment
    pr.comments.select{ |c| c.user.login == pr.creator }[-1]
  end

  def last_reviewer_comment
    pr.comments.select{ |c| c.user.login != pr.creator }[-1]
  end
end