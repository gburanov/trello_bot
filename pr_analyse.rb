require 'github_api'

require_relative 'validations/no_reviews'
require_relative 'validations/not_reviewed'
require_relative 'validations/unanswered_comments'

Github.configure do |c|
  c.basic_auth = ENV["GITHUB_AUTH"]
end

class PrAnalyse
  attr_reader :url
  attr_reader :notifier

  def initialize(url, notifier = nil)
    @url = url
    @notifier = notifier
  end

  def call
    if Github.new.pull_requests.merged?(org, name, number)
      puts "#{url} already merged, next one"
      return
    end
    return unless NoReviewsValidation.new(self, notifier).call
    if not_approved_reviewers.count == 0
      puts "#{url} is approved already"
      return
    end
    return unless UnansweredCommentsValidation.new(self, notifier).call
    return unless NotReviewedValidation.new(self, notifier).call
  end

  def last_author_comment
  end

  def last_commit_time
    commits[-1].commit.committer.date
  end

  def time_diff
    Time.now() - Time.parse(pr.updated_at)
  end

  def creator
    pr.user.login
  end

  def not_approved_reviewers
    not_approved_reviews.map{ |r| r.user.login }.uniq - [creator]
  end

  def comments
    @comments ||= Github.new.pull_requests.comments.get(user: org, repo: name, number: number, direction: 'desc', sort: 'created')
  end

  def commits
    @commits ||= Github.new.pull_requests.commits(org, name, number).last_page
  end

  def reviews
    @reviews ||= Github.new.pull_requests.reviews.list(org, name, number).last_page
  end

  def pr
    @pr ||=  Github.new.pull_requests.get(org, name, number)
  end

  def not_approved_reviews
    reviews.select{ |r| r.state != 'APPROVED' }
  end

  def spilit
    @splitted ||= url.split('/')
  end

  def number
    spilit[-1]
  end

  def name
    spilit[-3]
  end

  def org
    spilit[-4]
  end
end