#!/bin/bash
export DEBIAN_FRONTEND='noninteractive'
export DEBCONF_NONINTERACTIVE_SEEN='true'
export LC_ALL=
export LANG=en_GB.UTF-8
export LC_CTYPE="en_GB.UTF-8"
export LC_NUMERIC="en_GB.UTF-8"
export LC_TIME="en_GB.UTF-8"
export LC_COLLATE="en_GB.UTF-8"
export LC_MONETARY="en_GB.UTF-8"
export LC_MESSAGES="en_GB.UTF-8"
export LC_PAPER="en_GB.UTF-8"
export LC_NAME="en_GB.UTF-8"
export LC_ADDRESS="en_GB.UTF-8"
export LC_TELEPHONE="en_GB.UTF-8"
export LC_MEASUREMENT="en_GB.UTF-8"
export LC_IDENTIFICATION="en_GB.UTF-8"
export LANGUAGE=


rm /etc/resolv.conf
echo 'nameserver 8.8.8.8
nameserver 8.8.4.4' >/etc/resolv.conf


echo "setup locale lang"
locale-gen en_GB en_GB.UTF-8
update-locale LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8
locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8


echo "Instal base system packages"
apt update
apt upgrade -y
apt install -y apt-transport-https apt-utils software-properties-common
apt install -y gnupg gnupg-l10n gnupg-utils gpg gpg-agent gpg-wks-client gpg-wks-server gpgconf gpgsm gpgv
apt install -y dialog nano vim wget curl unzip gnupg2


echo "Add Husarnet repository key file"
curl https://install.husarnet.com/key.asc | apt-key add -


apt install -y openssh-client openssh-server openssh-sftp-server
apt install -y ntp libdw-dev libserial-dev can-utils

echo "remove iot edge"
apt-get remove --purge -y iotedge
apt-get remove --purge -y moby-cli
apt-get remove --purge -y moby-engine

echo "remove old docker versions"
apt-get remove -y docker docker-engine docker.io containerd runc

echo "install docker"
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose



echo "Create user Husarion"
groupadd gpio
groupadd docker
userdel -r husarion
useradd --create-home husarion
adduser husarion sudo
adduser husarion tty
adduser husarion video
adduser husarion plugdev
adduser husarion dialout
adduser husarion audio
adduser husarion lp
adduser husarion adm
adduser husarion gpio
gpasswd -a husarion docker

systemctl enable ssh

echo "install docker"

echo "Set passwords for root and husarion"
echo 'root:password' | chpasswd
echo 'husarion:husarion' | chpasswd
echo 'husarion' >/etc/hostname


sudo apt update && sudo apt upgrade -y
curl -sSL https://get.docker.com | sh
sudo apt install -y libffi-dev libssl-dev python3 python3-pip python3-setuptools
sudo apt remove -y python-configparser
sudo pip3 install -y docker-compose


echo "Setting time server"
echo "restrict 10.15.20.0 mask 255.255.255.0 nomodify notrap
server 127.127.1.0 prefer
fudge 127.127.1.0 stratum 6
driftfile /var/lib/ntp/ntp.drift
restrict default nomodify notrust
restrict 127.0.0.0/8
disable auth
logfile /var/log/ntp.log" >>/etc/ntp.conf


echo "
export ROS_MASTER_URI=http://10.15.20.3:11311
export ROS_IP=10.15.20.3
export ROS_IPV6=off
export ROBOT_VER=PANTHER_DOCKER" >>/home/husarion/.bashrc



echo '127.0.0.1	localhost master husarion

The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback master husarion
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters' >/etc/hosts


export ROS_MASTER_URI=http://10.15.20.3:11311
export ROS_IP=10.15.20.3

chsh -s /bin/bash husarion

. /home/husarion/.bashrc

# To run use following commands (in readme): 
#docker pull khasreto/panther_system_ros1:latest
#docker run  --net=host -e ROS_MASTER_URI -e ROS_IP -it -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev:/dev --privileged --name panther_system_ros1 khasreto/panther_system_ros1:latest ./upstart.bash


