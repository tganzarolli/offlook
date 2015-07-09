#!/bin/bash
echo "Make sure /usr/local has the right permissions"
sudo chown -R :admin /usr/local
sudo find /usr/local -perm -200 -exec chmod g+w '{}' \+
./bin/mongo_install.sh
./bin/rvm_install.sh
./bin/install.sh