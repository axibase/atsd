#!/usr/bin/env bash

if [ "$1" == "-h" ]; then
  echo "Usage: `basename $0` ATSD_HOSTNAME TCP_PORT [ENTITY]"
  exit 0
fi

exec 3<>/dev/tcp/"$1"/"$2"

metric="kafka.consumer_offset"
entity=${3-`hostname`}

# for Kafka versions before 0.10.2.0 use --zookeeper option instead bootstrap-server

exec env KAFKA_JMX_OPTS="" JMX_PORT="" $(dirname $0)/kafka-console-consumer.sh --consumer.config /tmp/consumer.config --formatter "kafka.coordinator.group.GroupMetadataManager\$OffsetsMessageFormatter" \
 --bootstrap-server localhost:9092 --topic __consumer_offsets --from-beginning | grep -v "\[.*\,.*_.*\,.*\]::.*\|\[.*\]::NULL" | awk -v entity="$entity" \
'match($0, /\[.*\]::/) { split(substr( $0, RSTART+1, RLENGTH-4 ), meta, ",") } \
 match($0, /OffsetMetadata\[([^,]+)/) { offset=substr( $0, RSTART+15, RLENGTH-15 ) } \
 match($0, /CommitTime\ ([^,]+)/) { time=substr( $0, RSTART+11, RLENGTH-11 )} \
 {print "series e:" entity " m:kafka.consumer_offset=" offset " t:groupid=\"" meta[1] "\" t:topic=\"" meta[2] "\" t:partition=" meta[3] " ms:" time}' >&3
