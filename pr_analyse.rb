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

    text = "#{url} can be reviewed for #{time_diff}"

    slack_users = not_approved_reviewers.map { |gu| GitHubToSlackMaper.new(gu).call }
    slack_users.each do |u|
      notifier.notify_person(u, text)
    end
  end

  private

  def time_diff
    Time.now() - Time.parse(pr.updated_at)
  end

  def creator
    pr.user.login
  end

  def not_approved_reviewers
    not_approved_reviews.map{ |r| r.user.login }.uniq - [creator]
  end

  def pr
    @pr ||=  Github.new.pull_requests.get(org, name, number)
  end

  def not_approved_reviews
    reviews.select{ |r| r.state != 'APPROVED' }
  end

  def reviews
    @reviews ||= Github.new.pull_requests.reviews.list(org, name, number)
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