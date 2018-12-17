require 'dotenv'
Dotenv.load

require 'byebug'
require 'awesome_print'

require_relative 'card_analyse'
require_relative 'slack_notifier'

notifier = SlackNotifier.new
PrAnalyse.new("https://github.com/remerge/audience_sync/pull/15", notifier).call
