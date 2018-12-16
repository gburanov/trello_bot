require 'trello'
require 'dotenv'

Dotenv.load

Trello.configure do |config|
  config.developer_public_key = TRELLO_DEVELOPER_PUBLIC_KEY # The "key" from step 1
  config.member_token = TRELLO_MEMBER_TOKEN # The token from step 2.
end