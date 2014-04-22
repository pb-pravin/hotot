class TestProducer
  include Hotot::MessageProducer
  
  def publish(message)
    produce TestMessage.new(message)
  end
  
end