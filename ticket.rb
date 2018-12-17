class CardAnalyse
  attr_reader :card

  def initialize(card)
    @card = card
  end

  def call
    prs.each do |url|
      PrAnalyse.new(url).call
    end
  end

  private

  def prs
    card.attachments.map(&:url).select{ |u| u.include?('github.com') }
  end
end