require 'minitest_helper'

describe "Hotot::Message::Base" do
  
  describe "default base" do
    
    before do
      @base = Hotot::Message::Base.new("rkey")
      @hash = @base.as_json
    end
  
    it "sets metadata" do
      metadata = @hash[:metadata]
      metadata[:app].must_equal "Hotot"
      metadata[:key].must_equal "rkey"
      metadata[:host].wont_be :empty?
      metadata[:created].wont_be :empty?
    end
    
    it "respond to to_json" do
      assert_respond_to @base, :to_json
    end
    
    it "converts to json" do
      json = @base.to_json
      metadata = (JSON.parse json)['metadata']
      
      metadata['app'].must_equal "Hotot"
      metadata['key'].must_equal "rkey"
      metadata['host'].wont_be :empty?
      metadata['created'].wont_be :empty?
    end
    
    it "gets routing_key" do
      @base.routing_key.must_equal "rkey"
    end
  
  end

end
