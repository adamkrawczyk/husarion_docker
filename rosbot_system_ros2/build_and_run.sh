#!/bin/bash


echo "To re-run use command docker start -i rosbot_system_ros2 "

echo "Setting usb properties"
chmod 666 /dev/ttyUSB0

docker build --tag rosbot_system_ros2:1.0 -t rosbot_system_ros2 .

docker run  --net=host -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev --privileged --name rosbot_system_ros2 rosbot_system_ros2 ./upstart.bash
# xhost -local:root