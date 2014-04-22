require 'logger'

module Hotot

  require_relative 'hotot/synchronous_connection'
  require_relative 'hotot/message_producer'
  require_relative 'hotot/message/base'
  
  def self.logger=(logger)
    @logger = logger
  end
  
  def self.logger
    @logger ||= Logger.new($stdout).tap do |log|
      log.progname = 'Hotot'
    end
  end
  
  def self.app_name=(app_name)
    @app_name = app_name
  end
  
  def self.app_name
    @app_name ||= "Hotot"
  end
  
end