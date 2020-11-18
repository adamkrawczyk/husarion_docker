#!/bin/bash


echo "To re-run use command docker start -i panther_system "

echo "Setting usb properties"
chmod 666 /dev/ttyUSB0

docker build --tag panther_system:1.0 -t panther_system .

# docker run --net=host -e ROS_MASTER_URI -it --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" -v /tmp/.X11-unix:/tmp/.X11-unix --name panther_system panther_system ./panther.bash

docker run  --net=host -e ROS_MASTER_URI -e ROS_IP -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev --privileged --name panther_system panther_system ./upstart.bash
# xhost -local:root