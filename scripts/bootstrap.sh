#!/bin/bash
#
# Copyright 2017 kkdt
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
# Software, and to permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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

echo "Install Node.js v11.x and npm v6.x"
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install xfce and virtualbox additions
sudo apt-get install -y xfce4 virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
# Permit anyone to start the GUI
# sudo sed -i 's/allowed_users=.*$/allowed_users=anybody/' /etc/X11/Xwrapper.config

#echo "Installing VirtualBox repo"
#cd /etc/yum.repos.d
#wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
#cd -

echo "Setting up /opt/bin"
mkdir -p /opt/bin
chmod 755 /opt/bin

globalsource=/etc/profile.d/$(hostname -s).sh
echo "Setting up $globalsource defaults"
touch $globalsource
chmod 755 $globalsource
echo "export PATH=/usr/local/bin:/opt/bin:$""PATH" >> $globalsource
