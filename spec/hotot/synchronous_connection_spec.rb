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
    @bunny       = Minitest::Mock.new
    @exchange    = Minitest::Mock.new
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
      @bunny = Hotot::SynchronousConnection.bunny
    end
    
    after do
      Hotot::SynchronousConnection.disconnect
    end
    
    it "calls start and exchange" do
      Hotot::SynchronousConnection.connect
      Hotot::SynchronousConnection.connected?.must_equal true
      assert_send [@bunny, :start]
      assert_send [@bunny, :exchange, "heyook.topic", :type => :topic, :durable => true]
    end
    
    describe "publish" do
      
      it "let exchange to publish" do
        Hotot::SynchronousConnection.connect
        @exchange = Hotot::SynchronousConnection.exchange
        
        message = TestMessage.new
        Hotot::SynchronousConnection.produce message
        assert_send [@exchange, :publish, message.to_json, :routing_key => "heyook.message.test", :mandatory => false, :immediate => false, :persistent => true, :content_type => "application/json"]
      end
      
    end
      
  end
  
  describe "disconnect" do
    
    it "disconnects and set connected to false" do
      Bunny.stub :new, @bunny do
        Hotot::SynchronousConnection.disconnect
        Hotot::SynchronousConnection.connected?.must_equal false
      end    
    end
    
  end
  
end