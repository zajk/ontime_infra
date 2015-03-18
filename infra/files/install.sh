#!/bin/bash

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
sudo echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get -y update
sudo apt-get install -y mongodb-org nginx git
sudo apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
sudo curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install nodejs build-essential
sudo npm install forever -g
sudo useradd -m app
sudo -H -u app bash -c 'cd $HOME; git clone https://github.com/tarikmlaco/cityTransport.git'
sudo -H -u app bash -c 'cd $HOME/cityTransport; npm install'
sudo -H -u app bash -c 'cd $HOME/cityTransport; forever start server.js'
sudo cp -a /home/app/cityTransport/public /usr/share/nginx/html/
sudo chown -R www-data:www-data /usr/share/nginx/html/public