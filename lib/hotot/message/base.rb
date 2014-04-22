require 'time'
require 'json' unless defined?(::Rails)

module Hotot
  module Message
    class Base
    
      # Use rails default json if it exists
      if defined?(::Rails)
        include ActiveModel::Serializers::JSON
      else
        define_method :to_json do
          self.as_json.to_json
        end
      end
    
      attr_reader :metadata

      def initialize(routing_key=nil)
        raise StandardError, "routing_key cannot be nil" if routing_key.nil?
        @metadata = {:host => Socket.gethostbyname(Socket.gethostname).first,
                     :app => Hotot.app_name, # configure this...
                     :key => routing_key,
                     :created => DateTime.now.new_offset(0).to_time.utc.iso8601}
      end

      def routing_key
        @metadata[:key]
      end

      def as_json(options={})
        hash = {:metadata => {:host => @metadata[:host],
                              :app => @metadata[:app],
                              :key => @metadata[:key],
                              :created => @metadata[:created]}}
        hash
      end
      
      
    end
  end
end