require 'trello'

Trello.configure do |config|
  config.developer_public_key = ENV["TRELLO_KEY"]
  config.member_token = ENV["TRELLO_TOKEN"]
end

class CardAnalyse
  attr_reader :card
  attr_reader :notifier

  def initialize(card, notifier = nil)
    @card = card
    @notifier = notifier
  end

  def call
    prs.each do |url|
      PrAnalyse.new(url, notifier).call
    end
  end

  private

  def prs
    card.attachments.map(&:url).select{ |u| u.include?('github.com') }
  end
end