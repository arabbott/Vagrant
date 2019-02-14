#!/bin/bash
#
# Copyright 2019 Northstrat, Inc.
#

# Base virtual machine initialization script.
# - hostname setup
# - install base packages from yum
#

#echo "Changing hostname to $virtualname"
#sudo hostnamectl set-hostname $virtualname.local
#sudo hostnamectl status
#sudo /etc/init.d/network restart

#echo "Updating box image"
#!/usr/bin/env bash

sudo apt-get update

echo "Setting up /opt/bin"
mkdir -p /opt/bin
chmod 755 /opt/bin

globalsource=/etc/profile.d/$(hostname -s).sh
echo "Setting up $globalsource defaults"
touch $globalsource
chmod 755 $globalsource
echo "export PATH=/usr/local/bin:/opt/bin:$""PATH" >> $globalsource
