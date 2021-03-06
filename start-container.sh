#!/bin/bash

# the default node number is 3
# N is the node number of hadoop cluster
N=$1

if [ $# = 0 ]
then
	echo "The default node number is 3!"
	N=3
fi

HADOOP_HOME=/usr/local/hadoop

# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=mybridge \
                -p 50070:50070 \
                -p 8088:8088 \
                -p 10022:22 \
                --name hadoop-master \
                --hostname hadoop-master \
                --privileged \
                madaibaba/hadoop-on-docker:2.0 &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=mybridge \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                --privileged \
	                madaibaba/hadoop-on-docker:2.0 &> /dev/null
	i=$(( $i + 1 ))
done 

# update slaves
rm -f slaves
i=1
while [ $i -lt $N ]
do
	echo "hadoop-slave$i" >> slaves
	i=$(( $i + 1 ))
done 
sudo docker cp slaves hadoop-master:$HADOOP_HOME/etc/hadoop
i=1
while [ $i -lt $N ]
do
	sudo docker cp slaves hadoop-slave$i:$HADOOP_HOME/etc/hadoop
	i=$(( $i + 1 ))
done 
rm -f slaves

# start cluster
sudo docker exec -it hadoop-master /root/start-hadoop.sh

# get into hadoop master container
sudo docker exec -it hadoop-master bash
