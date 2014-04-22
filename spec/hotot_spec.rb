require 'minitest_helper'

describe Hotot do
  
  describe "default settings" do
    
    before do 
      Hotot.logger   = nil
      Hotot.app_name = nil
    end
  
    it "uses default logger" do
      assert_kind_of Logger, Hotot.logger
    end
  
    it "uses default app name" do
      Hotot.app_name.must_equal "Hotot"
    end
  
  end
  
  describe "get/set settings" do
    
    it "sets logger" do
      logger_klass = Object.const_set("MyLogger", Class.new )
      Hotot.logger = logger_klass.new
      assert_kind_of logger_klass, Hotot.logger
    end
  
    it "sets app name" do
      Hotot.app_name = "New Rabbit"
      Hotot.app_name.must_equal "New Rabbit"
    end
    
  end
  
end
