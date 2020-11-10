echo "To re-run use command

 `docker run -i rap`"

xhost +local:root

docker build -q --tag husarion-route-admin-panel:1.0 -t rap .

docker run --net=host -e ROS_MASTER_URI -it --name rap rap ./panel.bash

xhost -local:root

# to re-run use command

# `docker run -i rap`
