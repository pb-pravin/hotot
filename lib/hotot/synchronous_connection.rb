require 'bunny'
require_relative 'configurable'
require_relative 'class_attribute_accessors'

module Hotot
  class SynchronousConnection
    extend Configurable
    extend ClassAttributeAccessors

    cattr_reader :bunny, :exchange

    @@setup = false
    @@connected = false

    def self.setup(config = nil, env = (defined?(::Rails) ? Rails.env : nil) )
      if !self.setup?
        @@config = load_config(config)
        @@env_config = @@config[env]
        raise StandardError, "Env #{env} not found in config" if @@env_config.nil?
        
        # symbolize the keys, which Bunny expects
        @@env_config.keys.each {|key| @@env_config[(key.to_sym rescue key) || key] = @@env_config.delete(key) }
        raise StandardError, "'exchange' key not found in config" if !@@env_config.has_key?(:exchange)
        
        @@bunny = Bunny.new(@@env_config)
        @@setup = true
      end
    end

    # Whether the underlying connection has been set up
    def self.setup?
      @@setup
    end
    
    def self.subscribe(routing_key, &block)
      q = @@bunny.queue.bind(@@env_config[:exchange], :routing_key => routing_key)

      q.subscribe do |delivery_info, metadata, payload|
        block.call delivery_info, metadata, payload
      end
      
    end

    # Establish a connection to the underlying exchange
    def self.connect
      raise StandardError, "AMQP not setup. Call setup before calling connect" if !self.setup?
      @@bunny.start
      
      # use defualt channel for exchange
      @@exchange = @@bunny.exchange(@@env_config[:exchange], :type => :topic, :durable => true)
      @@connected = true
    end

    # Disconnect from the underlying exchange
    def self.disconnect
      begin
        @@bunny.stop
      rescue
        # if this is being called because the underlying connection went bad
        # calling stop will raise an error. that's ok....
      ensure
        @@connected = false
      end
    end

    # Re-connects to the underlying exchange
    def self.reconnect
      self.disconnect
      @@setup = false
      @@bunny = Bunny.new(@@env_config)
      @@setup = true
      self.connect
    end

    # Whether the underlying connection has been established
    def self.connected?
      @@connected
    end

    # Produces a message to the underlying exchange
    def self.produce(message)
      if !self.setup? || !self.connected?
        Hotot.logger.error "AMQP not setup or connected. Call setup and connect before calling produce"
      else
        begin
          @@exchange.publish(message.to_json, :routing_key => message.routing_key, :mandatory => false, :immediate => false, :persistent => true, :content_type => "application/json")
        rescue Bunny::ServerDownError
          # the connection went south, try to reconnect and try one more time
          begin
            self.reconnect
            @@exchange.publish(message.to_json, :routing_key => message.routing_key, :mandatory => false, :immediate => false, :persistent => true, :content_type => "application/json")
          rescue => err
            Hotot.logger.error "Unexpected error producing AMQP messsage: (#{message.to_json})"
            Hotot.logger.error "#{err.message}"
            Hotot.logger.error err.backtrace.join("\n")
          end
        rescue => err
          Hotot.logger.error "Unexpected error producing AMQP messsage: (#{message.to_json})"
          Hotot.logger.error "#{err.message}"
          Hotot.logger.error err.backtrace.join("\n")
        end
      end
    end
    
  end #SynchronousConnection
end #Hotot