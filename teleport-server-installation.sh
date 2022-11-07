#!/bin/bash

################################## TELEPORT AUTH SERVER INSTALLATION ##################################

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
echo "version: v3" >> /etc/teleport/teleport.yaml
echo "teleport:" >> /etc/teleport/teleport.yaml 
echo "  nodename: $(hostname)" >> /etc/teleport/teleport.yaml
echo "  data_dir: /var/lib/teleport" >> /etc/teleport/teleport.yaml
echo "  log:" >> test.yaml 
echo "    output: stderr" >> test.yaml
echo "    severity: INFO" >> test.yaml 
echo "    format:" >> test.yaml 
echo "      output: text" >> test.yaml
echo -e "  ca_pin: \"\"" >> test.yaml 
echo -e "  diag_addr: \"\"" >> test.yaml 
echo "auth_service:" >> test.yaml 
echo -e "  enabled: \"yes\"" >> test.yaml