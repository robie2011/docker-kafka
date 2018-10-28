# Examples
Starting

    docker run -d -p 9092:9092 -p 2181:2181 robie2011/kafka



# Testing
## With Kafka Tools

```bash
# tools are available within docker container
# if you want to connect from local maschine, than you need to install these tools first:
#   kafka-bin: https://www.apache.org/dyn/closer.cgi?path=/kafka/2.0.0/kafka_2.11-2.0.0.tgz

# example: creating topic (not necessary, will auto-created)
bin/kafka-topics.sh --create --topic hello --zookeeper localhost:2181 --partitions 1 --replication-factor 1

# example: listen to data stream of topic: hello (you have to left this open)
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic hello --from-beginning

# example: produce messages to topic hello. 
# You can interactivly enter new line, which will interpreted as new message.
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic hello
```

## NodeJs
See https://www.npmjs.com/package/kafka-node

### Example Producer
```javascript
var kafka = require('kafka-node'),
    Producer = kafka.Producer,
    KeyedMessage = kafka.KeyedMessage,
    client = new kafka.KafkaClient({kafkaHost: 'localhost:9092'}),
    producer = new Producer(client),
    payloads = [
        { topic: 'hello', messages: 'hi' },
    ];
producer.on('ready', function () {
    console.log("sending");
    producer.send(payloads, function (err, data) {
        console.log(data);
    });
});

producer.on('error', function (err) { })
```

### Example Consumer
```javascript
var kafka = require('kafka-node'),
    client = new kafka.KafkaClient({kafkaHost: 'localhost:9092'}),
    consumer = new kafka.Consumer(client, [{
        topic: 'hello',
        offset: 0, //default 0
        partition: 0 // default 0
     }]);



consumer.on('message', function (message) {
    console.log(message);
});
```