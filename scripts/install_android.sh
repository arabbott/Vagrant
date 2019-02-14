#!/bin/bash
#
# Copyright 2019 Northstrat, Inc.
#

echo "Install Android Studio and SDK"
sudo apt-add-repository ppa:maarten-fonville/android-studio
sudo apt-get update
sudo apt-get install -y android-studio