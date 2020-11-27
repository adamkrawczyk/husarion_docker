#!/bin/bash


echo "To re-run use command docker start -i panther_system_ros1"

echo "Setting usb properties"
chmod 666 /dev/ttyUSB0

docker build --tag panther_system_ros1:1.0 -t panther_system_ros1 .

docker run  --net=host -e ROS_MASTER_URI -e ROS_IP -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev --privileged --name panther_system_ros1 panther_system_ros1 ./upstart.bash

# docker run  --net=host -e ROS_MASTER_URI -e ROS_IP -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev --privileged --name panther_system_ros1 khasreto/panther_system_ros1:1.0 ./upstart.bash
# 