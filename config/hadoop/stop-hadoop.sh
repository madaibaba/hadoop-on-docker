#!/bin/bash

echo -e "\n"

$HADOOP_HOME/sbin/hadoop-daemon.sh --script $HADOOP_HOME/bin/hdfs stop nfs3
$HADOOP_HOME/sbin/hadoop-daemon.sh --script $HADOOP_HOME/bin/hdfs stop portmap

echo -e "\n"

$HADOOP_HOME/sbin/stop-all.sh

echo -e "\n"

