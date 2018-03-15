#!/bin/bash

echo ""

echo -e "\nbuild docker hadoop-on-docker:1.0 image\n"
sudo docker build -t madaibaba/hadoop-on-docker:1.0 .

echo ""