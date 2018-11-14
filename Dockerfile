FROM java:8
RUN apt-get update -qq && apt-get install -y -qq vim wget --force-yes
RUN wget -qO- http://mirror.switch.ch/mirror/apache/dist/kafka/2.0.0/kafka_2.12-2.0.0.tgz | tar xvz -C /opt && \
    mv /opt/kafka* /opt/kafka && \
    mv /opt/kafka/config /opt/kafka/config-original-backup && \
    mkdir /tmp/kafka-logs/ && echo "test">/tmp/kafka-logs/empty.log
    

ADD config /opt/kafka/config
WORKDIR /opt/kafka
CMD bin/zookeeper-server-start.sh -daemon config/zookeeper.properties; bin/kafka-server-start.sh config/server.properties