module Hotot
  module MessageProducer
    # Produces a message to the underlying exchange using an synchronous connection
    def produce_synchronously(message)
      SynchronousConnection.produce(message)
    end
    alias :produce :produce_synchronously
  end
end