require 'dotenv'
Dotenv.load

require 'byebug'
require 'awesome_print'

require_relative 'card_analyse'
require_relative 'notifier/slack_notifier'
require_relative 'notifier/text_notifier'

notifier = SlackNotifier.new
# PrAnalyse.new("https://github.com/remerge/audience_sync/pull/15", notifier).call

#pr = PrAnalyse.new("https://github.com/remerge/proto/pull/43")
#byebug
#pr.reviews (7)

PrAnalyse.new('https://github.com/remerge/proto/pull/43', notifier).call


