require 'minitest_helper'

class TestMessage < Hotot::Message::Base
  ROUTING_KEY = "heyook.message.test"
  def initialize
    super ROUTING_KEY
  end
end

describe "Hotot::SynchronousConnection" do
  
  before do 
    @config_file = Pathname.new File.expand_path("../../fixtures/hotot.yml", __FILE__)
  end
  
  it "raise error if not setup yet" do
    assert_raises(StandardError) { Hotot::SynchronousConnection.connect }
  end
  
  describe "setup" do
    
    it "setup Hotot::SynchronousConnection" do
      Hotot::SynchronousConnection.setup @config_file, 'test'
      Hotot::SynchronousConnection.setup?.must_equal true
    end
    
  end
  
  describe "connect" do
    
    before do
      Hotot::SynchronousConnection.setup @config_file, 'test'
      @producer = Hotot::SynchronousConnection.producer
      @consumer = Hotot::SynchronousConnection.consumer
      Hotot::SynchronousConnection.connect
    end
    
    after do
      Hotot::SynchronousConnection.disconnect
    end
    
    it "calls start and exchange" do
      Hotot::SynchronousConnection.connected?.must_equal true
      assert_send [@producer, :start]
      assert_send [@producer, :exchange, "heyook.direct", :type => :direct, :durable => true]
    end
    
    describe "publish" do
      
      it "let exchange to publish" do
        @exchange = Hotot::SynchronousConnection.exchange
        
        message = TestMessage.new
        Hotot::SynchronousConnection.produce message
        assert_send [@exchange, :publish, message.to_json, :routing_key => "heyook.message.test", :mandatory => false, :immediate => false, :persistent => true, :content_type => "application/json"]
      end
      
    end
      
  end
  
  describe "disconnect" do
    
    it "disconnects and set connected to false" do
      Hotot::SynchronousConnection.disconnect
      Hotot::SynchronousConnection.connected?.must_equal false  
    end
    
  end
  
end