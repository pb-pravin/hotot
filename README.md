### Hotot

A bunny wrapper, based on [this](http://blog.brianploetz.com/post/36886084370/producing-amqp-messages-from-ruby-on-rails-applications) blog.

#### Setup bunny connection

```Ruby
Hotot::SynchronousConnection.setup config_file, env
```

with config file:
```Yaml
defaults: &defaults
  logging: false
  connection_timeout: 3
  host: localhost
  port: 5672
  vhost: "/"
  exchange: "hotot.topic"
  user: guest
  pass: guest

test:
  <<: *defaults

development:
  <<: *defaults

production:
  <<: *defaults
  host: queue.hotot.com
```

#### Connect and disconnect

```Ruby
# connect
Hotot::SynchronousConnection.connect

# check connection
Hotot::SynchronousConnection.connected?

# disconnect
Hotot::SynchronousConnection.disconnect
```

#### Subscribe

```Ruby
# setup a queue to subscribe
Hotot::SynchronousConnection.subscribe('hotot.message.test') do |delivery_info, metadata, payload|
  puts "Received #{payload}"
end
```

#### Produce

Sample message:
```Ruby
class TestMessage < Hotot::Message::Base
  ROUTING_KEY = "hotot.message.test"
  
  attr_reader :message
  
  def initialize(message)
    super ROUTING_KEY
    @message = message
  end

  def as_json(options={})
    hash = super
    hash[:message] = message
    hash
  end
  
end
```

Sample producer
```Ruby
class TestProducer
  include Hotot::MessageProducer
  
  def publish(message)
    produce TestMessage.new(message)
  end
  
end
```

Produce
```Ruby
  TestProducer.new.publish "hello hotot!"
```