require_relative 'user'

class Review
  def user
    User.new('richard')
  end

  def state
    'NOT_APPROVED'
  end
end

