#Politinder - Find your election night date

##About
Politinder is a vote matching app that works like a dating app. It includes faces of all candidates to elections of the European Parliament in 2014. The rationale behind this is that voting cohesion in the EP is above 90% for most topics and parliamentary groups. Candidate lists have been created by scraping and matching various data sources, candidate positions are based on the past voting behaviour (as opposed to statements of intent) of their (future) parliamentary group. <a href="http://www.votewatch.eu/votewatch.eu">Votewatch.eu</a> is used as a data source. 

Politinder was built at #Fajkhack, Stockholm.

## Installation

### Dependancies

	$ sudo apt-get install build-essential python-pip python-dev

and install virtualenv

	$ sudo pip install virtualenv

Please also install [CoffeeScript](http://coffeescript.org/)

### Setup a virtualenv and download dependances

	$ make install

### Run the server

	$ make run
