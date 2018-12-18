require_relative 'review'

class MockReviews < Array
  def initialize
    self << Review.new
    self << Review.new
  end

  def count_pages
    0
  end

  def count
    7
  end
end