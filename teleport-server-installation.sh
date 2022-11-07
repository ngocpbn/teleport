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
