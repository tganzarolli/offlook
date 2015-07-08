#!/bin/bash
 if [ -z "`mongo -version | grep version`" ]; then
	cd /tmp
	echo "Downloading MongoDB"
	curl https://fastdl.mongodb.org/osx/mongodb-osx-x86_64-3.0.4.tgz > mongodb.tgz
	echo "Inflating"
	tar -zxvf mongodb.tgz
	echo "Creating target directory /usr/local/mongodb"
	mkdir /usr/local/mongodb
	echo "Moving to /usr/local/mongodb/3.0.4"
	mv -n mongodb-osx-x86_64-3.0.4 /usr/local/mongodb/3.0.4
	echo "Creating data files at /data/db"
	sudo mkdir -p /data/db
	sudo chown `id -u` /data/db
	echo "Symlinking executable to /usr/local/bin/mongo"
	ln -s /usr/local/mongodb/3.0.4/bin/mongo /usr/local/bin/mongo
	echo "Creating log directories"
	sudo mkdir /var/log/mongodb
	sudo chmod 777 /var/log/mongodb
	echo "Launching MongoDB and making it default at startup"
	cd -
	sudo cp ./goodies/mongodb.plist /Library/LaunchDaemons/
	chown root /Library/LaunchDaemons/mongodb.plist
	sudo launchctl load /Library/LaunchDaemons/mongodb.plist
else
	echo "Mongo already installed"
fi