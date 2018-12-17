require 'github_api'

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

    if (Time.now() - 3.hours...Time.now()).cover?(pr.updated_at)
      puts "#{url} was created less then 3 hours ago"
      return 
    end

    notifier.message("#{not_approved_reviewers.join(', ')} for #{url} should be notified")
  end

  private

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