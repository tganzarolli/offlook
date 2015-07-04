# Offlook
# Pre-requisites
1. MongoDB
2. Ruby
3. To create your credentials file
  1. Get your exchange credentials.
  2. Create a Google App with Calendar access and copy the credentials.
  3. On your Google Calendar left panel, go to the Settings of a specific calendar and copy that id.
  4. That are two credentials sample files, just clone those files removing the *_sample* suffix then fill with correct data.

## To run
```MONGOID_ENV=development ruby ./syncher.rb```
## To test
```MONGOID_ENV=test rspec ./specs/```

##Known bugs:


##TODO:
* Deletion
* More recurrence tests
* Mock APIs for better testing
* Some form of scheduling mechanism