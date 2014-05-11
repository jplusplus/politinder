#!/usr/bin/env python
# Encoding: utf-8
# -----------------------------------------------------------------------------
# Project : Polinder
# -----------------------------------------------------------------------------
# Author : Edouard Richard                                  <edou4rd@gmail.com>
# -----------------------------------------------------------------------------
# License : GNU General Public License
# -----------------------------------------------------------------------------
# Creation : 10-May-2014
# Last mod : 10-May-2014
# -----------------------------------------------------------------------------
# This file is part of Polinder.
# 
#     Polinder is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     Polinder is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with Polinder.  If not, see <http://www.gnu.org/licenses/>.

import requests
from lxml import html
from pprint import pprint as pp
import twitter
import os, sys
import json

PAGES = [
	"https://politicsforpeople.eu/france/",
	"https://politicsforpeople.eu/sweden/",
	"https://politicsforpeople.eu/united-kingdom/",
	"https://politicsforpeople.eu/portugal/",
	"https://politicsforpeople.eu/spain/",
	"https://politicsforpeople.eu/ireland/",
	"https://politicsforpeople.eu/italy/",
	"https://politicsforpeople.eu/greece/",
	"https://politicsforpeople.eu/belgium/",
	"https://politicsforpeople.eu/netherlands/",
	"https://politicsforpeople.eu/germany/",
	"https://politicsforpeople.eu/denmark/",
	"https://politicsforpeople.eu/finland/",
	"https://politicsforpeople.eu/estonia/",
	"https://politicsforpeople.eu/latvia/",
	"https://politicsforpeople.eu/lithuania/",
	"https://politicsforpeople.eu/poland/",
	"https://politicsforpeople.eu/czech-republic/",
	"https://politicsforpeople.eu/austria/",
	"https://politicsforpeople.eu/slovakia/",
	"https://politicsforpeople.eu/hungary/",
	"https://politicsforpeople.eu/slovenia/",
	"https://politicsforpeople.eu/croatia/",
	"https://politicsforpeople.eu/romania/",
	"https://politicsforpeople.eu/bulgaria/",
	"https://politicsforpeople.eu/malta/",
	"https://politicsforpeople.eu/cyprus/",
]

def getTwitterPic(link):
	user_id = link.split("twitter.com/")[-1]
	api = twitter.Api(
		consumer_key        = os.getenv("TWITTER_CONSUMER_KEY"),
		consumer_secret     = os.getenv("TWITTER_CONSUMER_SECRET"),
		access_token_key    = os.getenv("TWITTER_TEST_ACCESS_TOKEN"),
		access_token_secret = os.getenv("TWITTER_TEST_ACCESS_TOKEN_SECRET")
	)
	user = api.GetUser(screen_name=user_id)
	image_url = user.GetProfileImageUrl().replace("_normal", "")
	local_filename = "pics/%s%s" % (user_id, os.path.splitext(image_url)[1])
	if not os.path.isfile(local_filename):
		r = requests.get(image_url, stream=True)
		with open(local_filename, 'wb') as f:
			for chunk in r.iter_content(chunk_size=1024): 
				if chunk: # filter out keep-alive new chunks
					f.write(chunk)
					f.flush()
	return local_filename

if __name__ == "__main__":

	results = []

	for page in PAGES:
		print >> sys.stderr, 'page', page
		r        = requests.get(page)
		document = html.fromstring(r.content)
		lines    = document.cssselect('.ginput_container li')
		for line in lines:
			entry = {
				"links"   : {},
				"country" : page.split("forpeople.eu/")[1].replace("/", ""),
				"name"    : line.find("label").text           if line.find("label") != None else "",
				"party"   : line.find_class("party")[0].text  if line.find_class("party")   else "",
				"region"  : line.find_class("region")[0].text if line.find_class("region")  else "",
			}
			for link in line.findall("a"):
				link = link.attrib["href"]
				if   "twitter"  in link: entry["links"]["twitter"]  = link
				elif "facebook" in link: entry["links"]["facebook"] = link
			if "twitter" in entry["links"]:
				try:
					entry["picture"] = getTwitterPic(entry["links"]["twitter"])
				except Exception as e:
					print >> sys.stderr, e
				results.append(entry)
			# pp(entry)
	print json.dumps(results)



# EOF
