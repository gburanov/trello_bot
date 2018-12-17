require 'github_api'

require_relative 'mapper'

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
    if reviews.count == 0
      puts "#{url} does not have reviews yet!"
      return
    end
    if not_approved_reviewers.count == 0
      puts "#{url} is approved already"
      return
    end
    if time_diff < 3.hours
      puts "#{url} was created less then 3 hours ago"
      return 
    end

    if comments[-1].user.login != creator || ap comments[-1].created_at > last_commit_time
      return 
    end

    NotReviewedValidation.new(pr, notifier).call
  end

  private

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
    @comments ||= Github.new.pull_requests.comments.list(org, name, number)
  end

  def commits
    @commits ||= Github.new.pull_requests.commits(org, name, number)
  end

  def reviews
    @reviews ||= Github.new.pull_requests.reviews.list(org, name, number)
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