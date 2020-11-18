# This is a Dockerfile for husarion
FROM osrf/ros:noetic-desktop-full
LABEL maintainer="adam.krawczyk@husarion.com"


# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt-get update && apt-get install -y -qq apt-utils
RUN apt-get install -y -qq dirmngr
RUN apt-get install -y -qq apt-transport-https software-properties-common
RUN apt-get install -y -qq lsb-release gnupg gnupg-l10n gnupg-utils gpg gpg-agent gpg-wks-client gpg-wks-server gpgconf gpgsm gpgv dialog nano vim wget curl unzip gnupg2
RUN apt-get install -y -qq ca-certificates
RUN apt-get remove -y cmdtest
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg --output pubkey.gpg
RUN apt-key add pubkey.gpg

RUN echo 'deb https://install.husarnet.com/deb/ all husarnet' >/etc/apt/sources.list.d/husarnet.list
RUN curl https://install.husarnet.com/key.asc | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_12.x --output setup.sh
RUN chmod a+x setup.sh
RUN ./setup.sh
RUN apt-get install -y -qq nodejs
RUN apt-get install -y -qq python3-pip
RUN apt-get install -y -qq openssl
RUN apt-get install -y -qq libserial-dev
RUN apt-get install -y -qq yarn
RUN apt-get install -y -qq net-tools
RUN apt-get install -y -qq xdg-utils 
RUN apt-get install -y -qq wget 
RUN apt-get install -y -qq libxtst6 
RUN apt-get install -y -qq libappindicator3-1
RUN apt-get install -y -qq git

# ROS depends
RUN apt-get install -y -qq ros-noetic-joint-state-controller ros-noetic-effort-controllers ros-noetic-position-controllers ros-noetic-gmapping
RUN apt install -y python3-argcomplete ros-noetic-slam-toolbox ros-noetic-teb-local-planner ros-noetic-move-base ros-noetic-teleop-twist-keyboard ros-noetic-robot-localization ros-noetic-ddynamic-reconfigure ros-noetic-behaviortree-cpp-v3 ros-noetic-ddynamic-reconfigure ros-noetic-rgbd-launch
RUN apt install ros-noetic-global-planner



# Add Intel display support by installing Mesa libraries
RUN apt-get install -y -qq libgl1-mesa-glx libgl1-mesa-dri 



RUN useradd --create-home husarion
RUN mkdir -p /home/husarion
RUN adduser husarion sudo
RUN echo 'Defaults !authenticate' >>/etc/sudoers


RUN echo "husarion:x:1000:1000:Developer,,,:/home/husarion:/bin/bash" >> /etc/passwd
RUN echo "husarion:x:1000:" >> /etc/group
RUN echo "husarion ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/husarion
RUN chmod 0440 /etc/sudoers.d/husarion

RUN echo ". /home/husarion/husarion_ws/devel/setup.sh" >> /home/husarion/.bashrc \
    && echo ". /usr/share/gazebo/setup.sh" >> /home/husarion/.bashrc

RUN chown husarion:husarion /home/husarion
USER husarion
ENV HOME /home/husarion
RUN mkdir -p /home/husarion/husarion_ws/src


WORKDIR /home/husarion/husarion_ws/src/
# ROS workspace
RUN git clone https://github.com/GT-RAIL/async_web_server_cpp.git
RUN git clone https://github.com/husarion/husarion_ros.git
RUN git clone https://github.com/husarion/route_admin_panel.git
RUN git clone https://github.com/husarion/panther_description.git
RUN git clone https://github.com/Slamtec/rplidar_ros.git
RUN git clone https://github.com/RobotWebTools/web_video_server.git


WORKDIR /home/husarion/husarion_ws
RUN rosdep update
RUN rosdep install --from-paths src --ignore-src -r -y

# RAP depends 
WORKDIR /home/husarion/husarion_ws/src/route_admin_panel/nodejs
RUN git checkout panther_dev
RUN npm install rosnodejs express socket.io quaternion-to-euler math3d multer yargs
# COPY package*.json ./
RUN npm install
# RUN yarn install

# build workspace
WORKDIR /home/husarion/husarion_ws
RUN . /opt/ros/noetic/setup.sh && catkin_make


# install custom launchfile
ADD upstart.bash /home/husarion/
ADD env.bash /home/husarion/

WORKDIR /home/husarion
