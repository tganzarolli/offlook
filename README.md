# Offlook
# Pre-requisites
1. MongoDB (you can run locally or point to some external DB at config/mongoid.yml)
2. Ruby and bundler (RVM recommended)
3. To create your credentials files:
  1. Get your exchange credentials from Outlook.
  2. Create a Google App with Calendar access and copy the credentials.
  3. On your Google Calendar left panel, go to the Settings of a specific calendar and copy that id.
  4. There are two credentials sample files, just clone those files removing the *_sample* suffix then fill with correct data.

## To run
* To display the help text:
```./syncher.rb -h```
* You can install everything from /bin if you have rvm.
* Also, look inside goodies for ways to schedule this script on OSX.

## To test
```MONGOID_ENV=test rspec ./specs/```

##Known bugs:

##TODO:
* Deletion
* More recurrence tests
* Mock APIs for better testing
