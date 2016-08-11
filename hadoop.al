## Function list
# hadoop related software
# - kafka (via confluent platform)
#  
#
## TODO 
# - find a better way to deal with multi-script starts than sleep
##

apps_root='/opt'

# HDFS
alias hd='hadoop fs'
alias hl='hd -ls'
alias hmkdir='hd -mkdir'
alias hcat='hd -cat'
alias hmv='hd -mv'
alias hcp='hd -cp'
alias hput='hd -put'
alias hcput='hd -copyFromLocal'
alias hcget='hd -copyToLocal'

## KAFKA
export confluent_root="$apps_root/confluent/cur"

khost='10.6.161.105'
inst='rbond'
cons='rbond'
topic='MAIVR2'

alias kafka_topics="curl -X GET http://$khost:8082/topics"

function kcreate {
  curl -X POST -H "Content-Type: application/vnd.kafka.v1+json" \
    --data "{\"name\": \"$inst\", \"format\": \"json\", \"auto.offset.reset\": \"smallest\"}" \
    http://$khost:8082/consumers/$cons
}

function kconsume {
  curl -X GET -H "Accept: application/vnd.kafka.json.v1+json" \
    http://$khost:8082/consumers/$cons/instances/$inst/topics/$topic
}

function kdelete {
  curl -X DELETE \
    http://$khost:8082/consumers/$cons/instances/$inst
}

#rfunction all{
#  kcreate()
#  kconsume()
#  kdelete()
#}


function ckafka {
  if [ $1 = "start" ]; then
    # zookeeper
    echo "CKAFKA: starting zookeeper"
    $confluent_root/bin/zookeeper-server-start $confluent_root/etc/kafka/zookeeper.properties &
    sleep 3
    # kafka
    echo "CKAFKA: starting kafka"
    $confluent_root/bin/kafka-server-start $confluent_root/etc/kafka/server.properties & 
    sleep 4
    #schema-registry
    echo "CKAFKA: starting schema-registry"
    $confluent_root/bin/schema-registry-start $confluent_root/etc/schema-registry/schema-registry.properties &
  elif [ $1 = "stop" ]; then
    # REST api
    $confluent_root/bin/kafka-rest-stop
    sleep 1
    #schema-registry
    $confluent_root/bin/schema-registry-stop
    sleep 3
    # kafka
    $confluent_root/bin/kafka-server-stop
    sleep 3
    # zookeeper
    $confluent_root/bin/zookeeper-server-stop
  else
    echo "expected args: [start|stop]"
  fi
}

function ckafka_rest {
  if [ $1 = "start" ]; then
    $confluent_root/bin/kafka-rest-start $confluent_root/etc/kafka-rest/kafka-rest.properties &
  elif [ $1 = "stop" ]; then
    $confluent_root/bin/kafka-rest-stop
  else
    echo "expected args: [start|stop]"
  fi
}
