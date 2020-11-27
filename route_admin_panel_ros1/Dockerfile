# This is a Dockerfile for husarion
FROM osrf/ros:melodic-desktop-full
LABEL maintainer="adam.krawczyk@husarion.com"


# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt-get update && apt-get install -y -qq apt-utils
RUN apt-get install -y -qq dirmngr
RUN apt-get install -y -qq apt-transport-https
RUN apt-get install -y -qq lsb-release
RUN apt-get install -y -qq ca-certificates
RUN apt-get remove -y cmdtest
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg --output pubkey.gpg
RUN apt-key add pubkey.gpg

RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_12.x --output setup.sh
RUN chmod a+x setup.sh
RUN ./setup.sh
RUN apt-get install -y -qq nodejs
RUN apt-get install -y -qq python-pip
RUN apt-get install -y -qq openssl
RUN apt-get install -y -qq ros-melodic-move-base
RUN apt-get install -y -qq libserial-dev
RUN apt-get install -y -qq yarn
RUN apt-get install -y -qq net-tools
RUN apt-get install -y -qq ros-melodic-grid-map
RUN apt-get install -y -qq ros-melodic-joint-state-controller
RUN apt-get install -y -qq ros-melodic-effort-controllers
RUN apt-get install -y -qq ros-melodic-position-controllers
RUN apt-get install -y -qq ros-melodic-gmapping
RUN apt-get install -y -qq xdg-utils 
RUN apt-get install -y -qq wget 
RUN apt-get install -y -qq libxtst6 
RUN apt-get install -y -qq libappindicator3-1

# Add Intel display support by installing Mesa libraries
RUN apt-get install -y -qq libgl1-mesa-glx libgl1-mesa-dri 



RUN useradd --create-home husarion
RUN mkdir -p /home/husarion

RUN echo "husarion:x:1000:1000:Developer,,,:/home/husarion:/bin/bash" >> /etc/passwd
RUN echo "husarion:x:1000:" >> /etc/group
RUN echo "husarion ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/husarion
RUN chmod 0440 /etc/sudoers.d/husarion

RUN echo ". /home/husarion/ros_ws/devel/setup.sh" >> /home/husarion/.bashrc

RUN chown husarion:husarion /home/husarion
USER husarion
ENV HOME /home/husarion
RUN mkdir -p /home/husarion/ros_ws/src


WORKDIR /home/husarion/ros_ws/src/
RUN git clone https://github.com/husarion/husarion_ros.git
RUN git clone https://github.com/husarion/rosbot_description.git
RUN git clone https://github.com/husarion/route_admin_panel.git

# RAP depends 
WORKDIR /home/husarion/ros_ws/src/route_admin_panel/nodejs
RUN npm install rosnodejs express socket.io quaternion-to-euler math3d multer yargs
# COPY package*.json ./
RUN npm install
# RUN yarn install

# build workspace
WORKDIR /home/husarion/ros_ws
RUN . /opt/ros/melodic/setup.sh && catkin_make


# install custom launchfile
ADD panel.bash /home/husarion/

WORKDIR /home/husarion

# RUN rm -rf /var/lib/apt/lists/*