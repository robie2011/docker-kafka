#!/bin/bash
cd /opt/kafka
bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
bin/kafka-server-start.sh -daemon config/server.properties

# didn't work because of unsupported filesystem type issue
# but is required to prevend exit docker container
tail -f /tmp/kafka-logs/*.log