#!/bin/bash
echo "To re-run use command docker start -i panther_sim"

xhost +local:root

docker build --tag panther:1.0 -t panther_sim .

docker run --net=host -it \
    --env="DISPLAY" \
    --runtime=nvidia \
    --env="QT_X11_NO_MITSHM=1" \
    --env=NVIDIA_VISIBLE_DEVICES=all \
    --env=NVIDIA_DRIVER_CAPABILITIES=all \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --name panther_sim panther_sim \
    ./panther.bash

xhost -local:root
