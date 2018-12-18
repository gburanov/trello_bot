require 'trello'

require_relative 'card_validations/all_approved'

require_relative 'pr_analyse'

Trello.configure do |config|
  config.developer_public_key = ENV["TRELLO_KEY"]
  config.member_token = ENV["TRELLO_TOKEN"]
end

class CardAnalyse
  attr_reader :card
  attr_reader :notifier

  def self.in_review
    Trello::List.find(ENV['LIST_ID']).cards
  end

  def initialize(card, notifier = nil)
    @card = card
    @notifier = notifier
  end

  def call
    return unless AllApprovedValidation.new(self, notifier).call
    analysers.each { |a| a.call }
  end

  def url
    card.url
  end

  def creator
    analysers.first.creator
  end

  def unapproved_ps
    @unapproved_ps ||= analysers.reject { |a| a.approved? }
  end

  def reviewers
    @reviewers ||= analysers.map { |a| a.reviewers }.flatten.uniq
  end

  private

  def analysers
    @analysers ||= prs.map { |url|  PrAnalyse.new(self, url, notifier) }
  end

  def prs
    card.attachments.map(&:url).select{ |u| u.include?('github.com') }
  end
end