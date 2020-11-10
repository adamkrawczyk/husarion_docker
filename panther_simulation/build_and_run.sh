#!/bin/bash
echo "To re-run use command docker run -i rap"

xhost +local:root

docker build -q --tag panther:1.0 -t panther_sim .

docker run --net=host -e ROS_MASTER_URI -it --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" -v /tmp/.X11-unix:/tmp/.X11-unix --name panther_sim panther_sim ./panther.bash

xhost -local:root