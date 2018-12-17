class TextNotifier
  attr_reader :client

  def message(text)
    puts text
  end

  def notify_person(person, text)
    text = "Hey #{person}, #{text}"
    message(text)
  end
end