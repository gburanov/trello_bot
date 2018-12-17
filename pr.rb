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

    byebug
  end

  private

  def reviewers
    reviews.map{ |r| r.user.login }
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