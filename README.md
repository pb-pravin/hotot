### Hotot

A [bunny](https://github.com/ruby-amqp/bunny)'s [topic exchange](http://www.rabbitmq.com/tutorials/tutorial-five-python.html) wrapper, based on [this](http://blog.brianploetz.com/post/36886084370/producing-amqp-messages-from-ruby-on-rails-applications) blog.

#### Topic exchange

- Topic exchange is powerful and can behave like other exchanges.
- When a queue is bound with "#" (hash) binding key - it will receive all the messages, regardless of the routing key - like in fanout exchange.
- When special characters "*" (star) and "#" (hash) aren't used in bindings, the topic exchange will behave just like a direct one.

---

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

sample message:
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

sample producer:
```Ruby
class TestProducer
  include Hotot::MessageProducer
  
  def publish(message)
    produce TestMessage.new(message)
  end
  
end
```

producer publishes:
```Ruby
  TestProducer.new.publish "hello hotot!"
```

### License

Released under the MIT license.