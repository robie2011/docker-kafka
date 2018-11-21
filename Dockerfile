FROM java:8
RUN apt-get update -qq && apt-get install -y -qq vim wget --force-yes
RUN wget -qO- http://www.pirbot.com/mirrors/apache/kafka/2.0.1/kafka_2.11-2.0.1.tgz | tar xvz -C /opt && \
    mv /opt/kafka* /opt/kafka && \
    mv /opt/kafka/config /opt/kafka/config-original-backup && \
    mkdir /tmp/kafka-logs/ && echo "test">/tmp/kafka-logs/empty.log
    

ADD config /opt/kafka/config
WORKDIR /opt/kafka

# issue with zookeeper: https://stackoverflow.com/questions/39759071/error-while-starting-kafka-broker
CMD bin/zookeeper-server-start.sh -daemon config/zookeeper.properties && (bin/kafka-server-start.sh config/server.properties || echo "kafka start failed. restarting ... " && sleep 3 && bin/kafka-server-start.sh config/server.properties)
