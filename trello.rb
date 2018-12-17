require 'trello'
require 'dotenv'
require 'byebug'

require_relative 'ticket'
require_relative 'pr'
require_relative 'init'

Init.new.init_apis

list = Trello::List.find(ENV['LIST_ID'])
cards = list.cards

cards.each do |card|
  CardAnalyse.new(card).call
end

