#!/bin/bash
if [ -z "`rvm --version | grep rvm`" ]; then
	echo "Installing rvm and ruby"
	\curl -sSL https://get.rvm.io | bash -s stable --ruby
else
	echo "rvm already installed"
fi