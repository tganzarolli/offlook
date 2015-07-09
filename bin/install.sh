#!/bin/bash --login
echo "Installing ruby gems"
rvm gemset use offlook --create
gem install bundler --no-ri --no-rdoc
bundle
echo "Setting up Outlook credentials"
./syncher.rb -s
echo "Setting up Google Calendar Id"
./syncher.rb -c
echo "Setting up Google credentials and performing initial full synch. This may take a while"
./syncher.rb -fv
echo "Schedulling partial synch to run every hour"
cp ./goodies/com.zerowidth.launched.offlook.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/com.zerowidth.launched.offlook.plist
echo "All set. Enjoy!"