require_relative 'user'

class Comment
  def user
    User.new('gburanov')
  end

  def created_at
    Time.now()
  end

  def commiter
    Commiter.new
  end
end

class Commiter
  def date
    Time.now()
  end
end