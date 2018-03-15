#!/bin/bash

echo ""

echo -e "\nbuild docker hadoop-on-docker:2.0 image\n"
sudo docker build -t madaibaba/hadoop-on-docker:2.0 .

echo ""