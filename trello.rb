require 'trello'
require 'dotenv'
require 'byebug'

require_relative 'ticket'

Dotenv.load

Trello.configure do |config|
  config.developer_public_key = ENV["TRELLO_KEY"]
  config.member_token = ENV["TRELLO_TOKEN"]
end

list = Trello::List.find(ENV['LIST_ID'])
cards = list.cards

cards.each do |card|
  CardAnalyse.new(card).call
end

