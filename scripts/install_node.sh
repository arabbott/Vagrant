#!/bin/bash
#
# Copyright 2019 Northstrat, Inc.
#

echo "Install Node.js v11.x and npm v6.x"
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Install Yarn"
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get install -y yarn

# echo "Installing Node.js module: http-server"
#npm install http-server -g

globalsource=/etc/profile.d/$(hostname -s).sh
touch $globalsource
chmod 755 $globalsource
echo "alias ngserve='ng serve --host 0.0.0.0'" >> $globalsource

#echo "Installing Node.js module: Connect"
#npm install connect -g

#echo "Installing Node.js module: ServeStatic"
#npm install serve-static -g