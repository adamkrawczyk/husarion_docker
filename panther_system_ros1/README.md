## How to install and use

### Install

1. Download fresh image for your device 
2. When using Vizi-AI:
    - Connect your Vizi to Internet, insert SD card, plug in keyboard and power on.
    - Login using L:`root`, P:`root`
    - Enable ssh with following commands:
    
    ```
    sed -i 's/#PermitRootLogin prohibit-password /PermitRootLogin yes/' /etc/ssh/sshd_config
    systemctl enable ssh
    systemctl start ssh
    ip a # get your IP address for connection (should be under br-enp6s0)(#should be 10.15.20.3)
    ```
    - Upload file set_vizi-ai.sh (scp set_vizi-ai.sh root@10.15.20.3:/root)
    - Execute file `./set_vizi-ai.sh` - This will create user husarion with password husarion set your environment and also download container.
3. When not using script download image `

4. If you want to autostart:
```
touch /etc/systemd/system/docker-panther-system.service
```

To file /etc/systemd/system/docker-panther-system.service paste following code:
```
[Unit]
Description=Panther System ROS1 noetic Container
Requires=docker.service
After=docker.service NetworkManager.service time-sync.target

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a panther_system_ros1
ExecStop=/usr/bin/docker stop -t 2 panther_system_ros1

[Install]
WantedBy=local.target
```

Enable service

sudo systemctl enable docker-panther-system.service


### Usage

- If you have made an autostart then to access container use following command:

    `docker exec -it panther_system_ros1 /bin/bash`

- In case you haven't made an autostart use:

    `docker start -i panther_system_ros1`

    Then 

    `docker exec -it panther_system_ros1 /bin/bash`
