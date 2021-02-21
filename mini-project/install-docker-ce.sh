#!/bin/bash
#this script is idempotent. Its ok to run it multiple times while troubleshooting any errors
echo "watch the screen carefully for any errors"
sudo apt install apt-transport-https ca-certificates curl software-properties-common  gpg-agent -y  # install the essential packages
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -    # GPG key for the official Docker repository to your system
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"    # Add the Docker repository to APT sources
sudo apt update -y #update the package database with the Docker packages from the newly added repo:
apt-cache policy docker-ce #Make sure you are about to install from the Docker repo instead of the default Ubuntu repo
sudo apt install docker-ce  -y #Finally, install Docker
sudo systemctl enable docker    # enabled to start on boot
sudo systemctl restart docker   # restart docker once 
sudo systemctl status docker    # enabled to start on boot
echo -e "\n\n"
echo "make sure Docker service is in running state"
echo "checking docker version.." ; sleep 2

echo "Adding current user to docker group"
sudo usermod -aG docker ${USER}

echo "relogging into shell to apply the docker permissions. Enter the sudo password"
su - ${USER}
