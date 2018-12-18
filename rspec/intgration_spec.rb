require 'rspec'

require 'dotenv'
Dotenv.load

require 'byebug'
require 'awesome_print'

require_relative '../pr_analyse'
require_relative '../notifier/text_notifier'

describe PrAnalyse do
  let(:notifier) { TextNotifier.new }

  it 'shows correct prs count for pr' do
    pr = PrAnalyse.new("https://github.com/remerge/proto/pull/43")
    expect(pr.reviews.count).to eq 7
  end

  it 'shows correct prs count for pr' do
    pr = MockPrAnalyser.new("https://github.com/remerge/proto/pull/43")
    expect(pr.reviews.count).to eq 7
  end

  it 'notifies for audience_sync pr' do
    PrAnalyse.new("https://github.com/remerge/audience_sync/pull/15", notifier).call
    expect(notifier.texts[0]).to include('Hey @aleksandr.dorofeev, https://github.com/remerge/audience_sync/pull/15 has unanswered review')
  end

  it 'for anas review' do
    PrAnalyse.new("https://github.com/remerge/proto/pull/43", notifier).call
    expect(notifier.texts[0]).to include('Hey @richard')
    expect(notifier.texts[1]).to include('Hey @martin')
  end
end