#!/bin/bash


echo "To re-run use command docker start -i rosbot_system "

echo "Setting usb properties"
chmod 666 /dev/ttyUSB0

docker build --tag rosbot_system:1.0 -t rosbot_system .

# docker run --net=host -e ROS_MASTER_URI -it --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" -v /tmp/.X11-unix:/tmp/.X11-unix --name rosbot_system rosbot_system ./panther.bash

docker run  --net=host -e ROS_MASTER_URI -e ROS_IP -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev --privileged --name rosbot_system rosbot_system ./upstart.bash
# xhost -local:root