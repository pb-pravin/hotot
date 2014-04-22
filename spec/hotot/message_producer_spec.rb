require 'minitest_helper'

class MyProducer
  include Hotot::MessageProducer
end

describe "Hotot::MessageProducer" do
  
  before do 
    @mp  = MyProducer.new
  end
  
  it "SynchronousConnection should receive produce" do
    Hotot::SynchronousConnection.stub :produce, true do
      @mp.produce "hello rabbit"
      assert_send [Hotot::SynchronousConnection, :produce, "hello rabbit"]
    end
  end
  
end