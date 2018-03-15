#!/bin/bash

echo -e "\n"

systemctl stop nfs.service
systemctl stop rpcbind.socket
systemctl stop rpcbind.service

echo -e "\n"

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

echo -e "\n"

$HADOOP_HOME/sbin/hadoop-daemon.sh --script $HADOOP_HOME/bin/hdfs start portmap
$HADOOP_HOME/sbin/hadoop-daemon.sh --script $HADOOP_HOME/bin/hdfs start nfs3

echo -e "\n"

