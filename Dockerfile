FROM centos:7

MAINTAINER houalex <houalex@gmail.com>

WORKDIR /root

# install openssh-server, openjdk and wget
RUN yum -y update
RUN yum install -y bash which openssh-server openssh-clients java-1.8.0-openjdk java-1.8.0-openjdk-devel wget initscripts nfs-utils rpcbind

# config sshd
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN echo 'root:123456'|chpasswd
EXPOSE 22

# install hadoop 2.7.5
RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.7.5/hadoop-2.7.5.tar.gz && \
    tar -xzvf hadoop-2.7.5.tar.gz && \
    mv hadoop-2.7.5 /usr/local/hadoop && \
    rm hadoop-2.7.5.tar.gz

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HDFS_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HADOOP_LIBEXEC_DIR=$HADOOP_HOME/libexec
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin 

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs && \
	mkdir /tmp/hadoop

COPY config/hadoop/* /tmp/hadoop/

RUN mv /tmp/hadoop/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hadoop/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/hadoop/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/hadoop/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/hadoop/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/hadoop/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/hadoop/stop-hadoop.sh ~/stop-hadoop.sh && \
    mv /tmp/hadoop/run-wordcount.sh ~/run-wordcount.sh && \
    echo "log4j.logger.org.apache.hadoop.hdfs.nfs=DEBUG" >> $HADOOP_HOME/etc/hadoop/log4j.properties && \
    echo "log4j.logger.org.apache.hadoop.oncrpc=DEBUG" >> $HADOOP_HOME/etc/hadoop/log4j.properties

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/stop-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x $HADOOP_HOME/sbin/stop-all.sh

# format namenode
RUN /usr/local/hadoop/bin/hadoop namenode -format

RUN systemctl enable sshd.service && \
    systemctl disable rpcbind.service && \
    systemctl disable nfs.service

CMD /usr/sbin/init
