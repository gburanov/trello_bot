require 'trello'
require 'github_api'

class Init
  def init_apis
    puts "Initialization"

    Dotenv.load

    Trello.configure do |config|
      config.developer_public_key = ENV["TRELLO_KEY"]
      config.member_token = ENV["TRELLO_TOKEN"]
    end

    Github.configure do |c|
      c.basic_auth = ENV["GITHUB_AUTH"]
    end
  end
end

