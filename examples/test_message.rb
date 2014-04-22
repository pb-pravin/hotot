# TestMessage class
class TestMessage < Hotot::Message::Base
  ROUTING_KEY = "heyook.message.test"
  
  attr_reader :message
  
  def initialize(message)
    super ROUTING_KEY
    @message = message
  end

  def as_json(options={})
    hash = super
    hash[:message] = message
    hash
  end
  
end