#!/bin/bash

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

sudo apt-get install teleport

#------------------------------------

# STEP 2: SET UP THE .YAML CONFIGURATION FILE

echo "Making the directory /etc/teleport/"
sudo mkdir /etc/teleport/

sudo touch /etc/teleport/teleport.yaml

# The configuration file
CONFIG_FILE=/etc/teleport/teleport.yaml

echo "version: v3" >> $CONFIG_FILE    # You'll have to update this for each major release of Teleport
echo "teleport:" >> $CONFIG_FILE 
echo "  nodename: $(hostname)" >> $CONFIG_FILE
echo "  data_dir: /var/lib/teleport" >> $CONFIG_FILE
echo "  log:" >> $CONFIG_FILE 
echo "    output: stderr" >> $CONFIG_FILE
echo "    severity: INFO" >> $CONFIG_FILE 
echo "    format:" >> $CONFIG_FILE 
echo "      output: text" >> $CONFIG_FILE
echo -e "  ca_pin: \"\"" >> $CONFIG_FILE 
echo -e "  diag_addr: \"\"" >> $CONFIG_FILE 
echo "  auth_servers:" >> $CONFIG_FILE
echo -e "  - \"192.168.50.129:3025\"" >> $CONFIG_FILE       # You'll have to change the IP address accordingly.
echo -e "  auth_token: \"my-tok3nn\""
echo "auth_service:" >> $CONFIG_FILE 
echo -e "  enabled: \"no\"" >> $CONFIG_FILE 
echo "  listen_addr: 0.0.0.0:3025" >> $CONFIG_FILE
echo "  tokens:" >> $CONFIG_FILE 
echo -e "    - \"node:my-tok3nn\"" >> $CONFIG_FILE
echo "  proxy_listener_mode: multiplex" >> $CONFIG_FILE
echo "ssh_service:" >> $CONFIG_FILE
echo -e "  enabled: \"yes\"" >> $CONFIG_FILE
echo "  commands:" >> $CONFIG_FILE 
echo "  - name: SCS" >> $CONFIG_FILE 
echo "    period: 1m0s" >> $CONFIG_FILE
echo "    command: [hostname]" >> $CONFIG_FILE 
echo "    period: 1m0s" >> $CONFIG_FILE
echo "proxy_service:" >> $CONFIG_FILE 
echo -e "  enabled: \"no\"" >> $CONFIG_FILE 
echo "  https_keypairs: []" >> $CONFIG_FILE
echo "  acme: {}" >> $CONFIG_FILE

#------------------------------------

# STEP 3: RUN TELEPORT AS A DAEMON
sudo systemctl enable teleport.service
sudo systemctl start teleport

#------------------------------------

# STEP 4: CONFIGURE FIREWALL
sudo ufw allow 3022/tcp