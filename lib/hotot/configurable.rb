require 'erb'
require 'yaml'

module Hotot
  module Configurable

    private

    def load_config(config_file = nil)
      if config_file && config_file.file?
        YAML.load(ERB.new(config_file.read).result)
      elsif defined?(::Rails)
        config_file = ::Rails.root.join('config/hotot.yml')
        if config_file.file?
          YAML.load(ERB.new(config_file.read).result)
        else
          nil
        end
      end
    end
    
  end
end