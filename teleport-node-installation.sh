#!/bin/bash

# Run this script in a root shell or with the command "sudo ./teleport-node-installation.sh"

################################## TELEPORT NODE INSTALLATION ##################################

# STEP 1: DOWNLOAD THE BINARY FILE  

sudo curl https://apt.releases.teleport.dev/gpg \
  -o /usr/share/keyrings/teleport-archive-keyring.asc

source /etc/os-release

# Add the Teleport APT repository for v11. You'll need to update this
# file for each major release of Teleport.
echo "deb [signed-by=/usr/share/keyrings/teleport-archive-keyring.asc] \
  https://apt.releases.teleport.dev/${ID?} ${VERSION_CODENAME?} stable/v11" \
| sudo tee /etc/apt/sources.list.d/teleport.list > /dev/null

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install teleport

#------------------------------------

# STEP 2: SET UP THE .YAML CONFIGURATION FILE

echo "Making the directory /etc/teleport/"
sudo mkdir /etc/teleport/

sudo touch /etc/teleport/teleport.yaml

# The configuration file
CONFIG_FILE=/etc/teleport/teleport.yaml

# You'll have to change the line "version" for each major release of Teleport
# You'll have to change the IP address accordingly.
echo -e "version: v3     
teleport: 
  nodename: $(hostname) 
  data_dir: /var/lib/teleport 
  log: 
    output: stderr 
    severity: INFO 
    format: 
      output: text
  ca_pin: \"\" 
  diag_addr: \"\" 
  auth_servers:
  - \"192.168.50.129:3025\"
  auth_token: \"my-tok3nn\"
auth_service: 
  enabled: \"no\" 
  listen_addr: 0.0.0.0:3025
  proxy_listener_mode: multiplex
ssh_service:
  enabled: \"yes\"
  commands: 
  - name: SCS 
    command: [hostname] 
    period: 1m0s
proxy_service: 
  enabled: \"no\" 
  https_keypairs: []
  acme: {}" >> $CONFIG_FILE

#------------------------------------

# STEP 3: RUN TELEPORT AS A DAEMON
echo -e "[Unit]
Description=Teleport Service
After=network.target

[Service]
Type=simple
Restart=on-failure
EnvironmentFile=-/etc/default/teleport
ExecStart=/usr/local/bin/teleport start --config=/etc/teleport/teleport.yaml --pid-file=/run/teleport.pid
ExecReload=/bin/kill -HUP \$MAINPID
PIDFile=/run/teleport.pid
LimitNOFILE=8192

[Install]
WantedBy=multi-user.target" >> /usr/lib/systemd/system/teleport.service
sudo systemctl enable teleport.service
sudo systemctl start teleport

#------------------------------------

# STEP 4: CONFIGURE FIREWALL
sudo ufw allow 3022/tcp