class Validation
  attr_reader: :pr
  attr_reader: :notifier

  def initialize(pr, notifier)
    @pr = pr
    @notifier = notifier
  end
end