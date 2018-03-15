## Hadoop on Docker Containers


![alt tag](https://raw.githubusercontent.com/madaibaba/hadoop-on-docker/master/hadoop-on-docker.png)


#### 1. Clone Github Repository

```
git clone https://github.com/madaibaba/hadoop-on-docker
```

#### 2. Pull Docker Image

```
sudo docker pull madaibaba/hadoop-one-docker:1.0
```

#### 3. Create My Bridge Network

```
sudo docker network create -d bridge mybridge
```

#### 4. Start Docker Container

##### 4.1 Start Three Container for default (one master and two slaves)

```
cd hadoop-on-docker
sudo ./start-container.sh
```

##### 4.2 Start six Container as below (one master and five slaves)

```
cd hadoop-on-docker
sudo ./start-container.sh 6
```
