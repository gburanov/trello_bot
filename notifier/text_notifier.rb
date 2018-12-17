class TextNotifier
  attr_reader :client
  attr_reader :texts

  def initialize
    @texts = []
  end

  def message(text)
    puts text
    @texts << text
  end

  def notify_person(person, text)
    text = "Hey #{person}, #{text}"
    message(text)
  end
end