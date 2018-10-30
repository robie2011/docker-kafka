# Starting
docker run

    docker run -d -p 9092:9092 -p 2181:2181 robie2011/kafka

custom configuration: To override defaults, you can e.g. map `/config` folder

    docker run -d -p 9092:9092 -p 2181:2181 -v$(pwd):/opt/kafka/config robie2011/kafka



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

# Administration

## delete topic
    bin/kafka-topics.sh --delete --topic Hello --zookeeper localhost:2181

## get topic size in bytes
Shellscript output is JSON-String. For extracting bytes npm-module `node-jq` is used. See https://www.npmjs.com/package/node-jq

    bin/kafka-log-dirs.sh --bootstrap-server 127.0.0.1:9092 --topic-list 'CoinbaseTicker' --describe | tail -n 1 | jq '.brokers[]?.logDirs[].partitions[].size'


## create topic with custom configuration
    
    bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic my-topic --partitions 1 --replication-factor 1 --config max.message.bytes=64000 --config flush.messages=1

## topic configuration
See [kafka.apache.org, Documentation - 3.2 Topic-Level Configs](https://kafka.apache.org/documentation/#topicconfigs)


    bin/kafka-configs.sh --zookeeper zoo1.example.com:2181/kafka-cluster --alter --entity-type topics --entity-name <topicame> --add-config <key>=<value>[,<key>=<value>...]


Example: Set topic `retention.ms = 60000`. Messages will be delete after 1 min.

    bin/kafka-configs.sh --zookeeper localhost:2181 --alter --entity-type topics --entity-name CoinbaseTicker --add-config retention.ms=60000

Example: Delete configuration

    bin/kafka-configs.sh --zookeeper localhost:2181  --entity-type topics --entity-name my-topic --alter --delete-config max.message.bytes

Example: Check overrides

    bin/kafka-configs.sh --zookeeper localhost:2181 --entity-type topics --entity-name my-topic --describe


