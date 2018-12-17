require 'dotenv'
Dotenv.load

require 'byebug'
require 'awesome_print'

require_relative 'card_analyse'
require_relative 'pr_analyse'
require_relative 'init'
require_relative 'notifier'

Init.new.init_apis

notifier = Notifier.new

list = Trello::List.find(ENV['LIST_ID'])
cards = list.cards

cards.each do |card|
  CardAnalyse.new(card, notifier).call
end