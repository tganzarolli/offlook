# Offlook
# Pre-requisites
1. MongoDB
2. Ruby
3. To create your credentials file
	a. Get your exchange credentials.
	b. Create a Google App with Calendar access and copy the credentials.
	c. On your Google Calendar left panel, go to the Settings of a specific calendar and copy that id.
	d. That are two credentials sample files, just clone those files removing the _sample suffix then fill with correct data.

## To run
```MONGOID_ENV=development ruby ./syncher.rb```
## To test
```MONGOID_ENV=development rspec ./specs/```

##Known bugs:
* Recurrence is not working, because the event only apperas once. It's needed to replicate manually.
* Access token expiring quickly.