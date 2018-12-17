# Mapping github/slack

class GitHubToSlackMaper
  attr_reader :github_user

  def initialize(github_user)
    @github_user = github_user
  end

  def call
    return 'martin' if github_user == 'dynamix'
    return 'richard' if github_user == 'itszootime'
    return 'gburanov' if github_user =='gburanov'
    raise "Unknown github user #{github_user}"
  end
end