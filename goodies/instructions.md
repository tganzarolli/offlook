## How to schedule to run on an OSX
### Configure the file
* Edit the plist file, replacing FILL_WITH_YOUR_PATH with the actual path of the project on your machine and FILL_WITH_YOUR_USER with your login user.
* It's schedule to run every hour (mimute zero), but you can change that.
* Copy the file to ~/Library/LaunchAgents/
### Double-check permissions and setup
Make sure the .sh files on this project's bin folder have the right permissions:
```chmod -R 755 bin```
Run: 
```bin/install.sh```
### Load: 
```launchctl load -w ~/Library/LaunchAgents/com.zerowidth.launched.offlook.plist```

## How-to
### Unload
```launchctl unload -w ~/Library/LaunchAgents/com.zerowidth.launched.offlook.plist```

## To debug:
```sudo launchctl log level debug```
```tail -f /var/log/system.log```
When done, return things to normal:
```sudo launchctl log level error```

### Or
Include this lines on the plist file, unload and load again. This will redirect every output and error to your first terminal:
```<key>StandardOutPath</key>
   <string>/dev/ttys000</string>
   <key>StandardErrorPath</key>
   <string>/dev/ttys000</string>```
