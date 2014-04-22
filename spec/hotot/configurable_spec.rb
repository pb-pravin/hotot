require 'minitest_helper'

module MyConfig
  extend Hotot::Configurable
  
  def self.setup(config)
    load_config(config)
  end
  
end

describe "Hotot::Configurable" do
  
  it "Configurable should receive load_config" do
    MyConfig.stub :load_config, true do
      MyConfig.setup "config"
      assert_send [MyConfig, :load_config, nil]
    end
  end
  
  before do 
    @config_file = Pathname.new File.expand_path("../../fixtures/hotot.yml", __FILE__)
    @config = MyConfig.setup @config_file
  end
  
  it "loads config file" do
    test_config = @config['test']
    test_config['host'].must_equal 'localhost'
    test_config['vhost'].must_equal '/'
    test_config['exchange'].must_equal 'heyook.topic'
  end
  
end

