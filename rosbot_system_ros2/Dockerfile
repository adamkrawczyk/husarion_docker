# This is a Dockerfile for husarion
FROM osrf/ros:foxy-desktop
LABEL maintainer="adam.krawczyk@husarion.com"


# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt-get update && apt-get install -y -qq apt-utils

# Instal base packages

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
RUN apt-get install -y -qq libxtst6 
RUN apt-get install -y -qq libappindicator3-1
RUN apt-get install -y -qq git

# ROS depends
RUN apt install -y python3-argcomplete ros-foxy-slam-toolbox ros-foxy-teleop-twist-keyboard 
RUN apt install -y ros-foxy-navigation2
RUN apt install -y ros-foxy-gazebo-ros ros-foxy-gazebo-dev ros-foxy-gazebo-msgs ros-foxy-gazebo-plugins ros-foxy-gazebo-ros-pkgs ros-foxy-xacro
RUN apt install -y ros-foxy-nav2-bringup ros-foxy-slam-toolbox libcunit1-dev
RUN apt install -y ros-foxy-rmw-cyclonedds-cpp ros-foxy-cyclonedds python3-colcon-common-extensions

RUN python3 -m pip install pyserial


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
# RUN git clone https://github.com/husarion/husarion_ros.git
RUN git clone --branch ros2 https://github.com/husarion/route_admin_panel.git
RUN git clone --branch ros2 https://github.com/husarion/rosbot_description.git
RUN git clone --branch ros2 https://github.com/allenh1/rplidar_ros.git
# RUN git clone https://github.com/husarion/rosbot_ekf.git


WORKDIR /home/husarion/husarion_ws
RUN rosdep update
RUN rosdep install --from-paths src --rosdistro foxy --ignore-src -r -y


# RAP depends 
WORKDIR /home/husarion/husarion_ws/src/route_admin_panel/nodejs
RUN npm install express socket.io quaternion-to-euler math3d multer yargs uuid 
# RUN npm i rclnodejs@0.16.0
# RUN wget https://forked-rclnodejs.s3-eu-west-1.amazonaws.com/rclnodejs-0.10.3.tgz
# RUN npm install --force rclnodejs-0.10.3.tgz
RUN npm install
# WORKDIR /home/husarion/husarion_ws/src/route_admin_panel/nodejs/node_modules/rclnodejs/
# RUN node scripts/generate_messages.js 

# build workspace
WORKDIR /home/husarion/husarion_ws
# RUN . /opt/ros/foxy/setup.sh && colcon build


# install custom launchfile
ADD upstart.bash /home/husarion/
ADD husarion_env.sh /home/husarion/

WORKDIR /home/husarion

# ENTRYPOINT ["/home/husarion/husarion_env.sh"]
CMD ["bash"]
