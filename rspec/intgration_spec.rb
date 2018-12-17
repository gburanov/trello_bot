require 'rspec'

require 'dotenv'
Dotenv.load

require 'byebug'

require_relative '../pr_analyse'
require_relative '../notifier/text_notifier'

describe PrAnalyse do
  let(:notifier) { TextNotifier.new }

  it 'shows correct prs count for pr' do
    pr = PrAnalyse.new("https://github.com/remerge/proto/pull/43")
    expect(pr.reviews.count).to eq 7
  end

  it 'notifies for audience_sync pr' do
    PrAnalyse.new("https://github.com/remerge/audience_sync/pull/15", notifier).call
    byebug
  end
end