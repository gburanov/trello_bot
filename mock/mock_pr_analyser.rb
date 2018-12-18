require_relative '../pr_analyse'

require_relative 'mock_reviews'
require_relative 'pr'
require_relative 'comment'

class MockPrAnalyser < PrAnalyse

  def merged?
    nil
  end

  def comments
    [Comment.new]
  end

  def commits
    nil
  end

  def pr
    @pr ||= Pr.new
  end

  def paginated_reviews
    @paginated_reviews ||= MockReviews.new
  end
end