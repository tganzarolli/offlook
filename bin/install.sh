#!/bin/bash --login -e
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
dir=`pwd`
sed -e s/FILL_WITH_YOUR_USER/`whoami`/g goodies/com.zerowidth.launched.offlook.plist | sed -e  "s/FILL_WITH_YOUR_PATH/${dir//\//\\/}/g" > /tmp/com.zerowidth.launched.offlook.plist
mv /tmp/com.zerowidth.launched.offlook.plist ~/Library/LaunchAgents/com.zerowidth.launched.offlook.plist
launchctl load -w ~/Library/LaunchAgents/com.zerowidth.launched.offlook.plist
echo "All set. Enjoy!"