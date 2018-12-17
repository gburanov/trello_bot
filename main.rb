require 'dotenv'
Dotenv.load

require 'byebug'
require 'awesome_print'

require_relative 'card_analyse'
require_relative 'slack_notifier'

notifier = SlackNotifier.new

cards = CardAnalyse.in_review

cards.each do |card|
  CardAnalyse.new(card, notifier).call
end