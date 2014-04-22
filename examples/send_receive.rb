#!/Users/he9qi/.rbenv/shims/ruby
# encoding: utf-8

require 'json'
require '../lib/hotot'
require './test_message'
require './test_producer'


# load config file
@config_file = Pathname.new File.expand_path("../spec/fixtures/hotot.yml", File.dirname(__FILE__))

# setup connection and connect
Hotot::SynchronousConnection.setup @config_file, 'test'
Hotot::SynchronousConnection.connect

puts "Connect status: #{Hotot::SynchronousConnection.connected?}" 

# give short time to connect
sleep 0.25

# setup a queue to subscribe
Hotot::SynchronousConnection.subscribe(TestMessage::ROUTING_KEY) do |delivery_info, metadata, payload|
  puts "Received #{payload}"
end

# produce message
message = "i am a messsage!"
TestProducer.new.publish message

# disconnect
sleep 0.1
Hotot::SynchronousConnection.disconnect
puts "disconnected"