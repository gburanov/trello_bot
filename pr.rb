require 'github_api'

class PrAnalyse
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def call
    if Github.new.pull_requests.merged?(org, name, number)
      puts "#{url} already merged, next one"
      return
    end
    if reviewers.count == 0
      puts "#{url} does not have reviewers"
      return
    end

    if (Time.now() - 3.hours...Time.now()).cover?(pr.updated_at)
      puts "#{url} was created less then 3 hours ago"
      return 
    end

    byebug
  end

  private

  def creator
    pr.user.login
  end

  def reviewers
    reviews.map{ |r| r.user.login }.flatten - [creator]
  end

  def pr
    @pr ||=  Github.new.pull_requests.get(org, name, number)
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