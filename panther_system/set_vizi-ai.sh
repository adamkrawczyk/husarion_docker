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
apt-get remove --purge iotedge
apt-get remove --purge moby-cli
apt-get remove --purge moby-engine

echo "remove old docker versions"
apt-get remove docker docker-engine docker.io containerd runc

echo "install docker"
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io
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
