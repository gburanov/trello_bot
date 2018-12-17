require 'github_api'

class Init
  def init_apis
    puts "Initialization"

    Dotenv.load

    Github.configure do |c|
      c.basic_auth = ENV["GITHUB_AUTH"]
    end
  end
end

