## Function list
# hadoop related software
# - kafka (via confluent platform)
#  
#
## TODO 
##

apps_root='/opt'

## KAFKA
confluent_root='$apps_root/confluent/cur'

function ckafka {
  if [ $1 = "start" ]; then
    # zookeeper
    $confluent_root/bin/zookeeper-server-start $confluent_root/etc/kafka/zookeeper.properties || return
    # kafka
    $confluent_root/bin/kafka-server-start $confluent_root/etc/kafka/server.properties || return
    #schema-registry
    $confluent_root/bin/schema-registry-start $confluent_root/etc/schema-registry/schema-registry.properties
  elif [ $1 = "stop" ]; then
    # zookeeper
    $confluent_root/bin/zookeeper-server-stop
    # kafka
    $confluent_root/bin/kafka-server-stop
    #schema-registry
    $confluent_root/bin/schema-registry-stop
  else
    echo "expected args: [start|stop]"
  fi
}

#function ckafka_rest {
#  
#}
