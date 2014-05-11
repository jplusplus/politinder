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
	"https://politicsforpeople.eu/sweden/",
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

for page in PAGES:
	r        = requests.get(page)
	document = html.fromstring(r.content)
	lines    = document.cssselect('.ginput_container li')
	break
	for line in lines:
		entry = {
			"links" : {},
			"name"  : line.find("label").text           if line.find("label") != None else "",
			"party" : line.find_class("party")[0].text  if line.find_class("party")   else "",
			"region": line.find_class("region")[0].text if line.find_class("region")  else "",
		}

		if 'vert' in entry['party'].lower():
			entry['party'] = 'The Greens'
		for link in line.findall("a"):
			link = link.attrib["href"]
			if "twitter"    in link: entry["links"]["twitter"]  = link
			elif "facebook" in link: entry["links"]["facebook"] = link
		if "twitter" in entry["links"] or "facebook" in entry["links"]:
			pass
		pp(entry)

#save entries into mongo


#replace or add party names with European parliamentary groups

def replace_parties(party, group):
    for key in politicians.keys():
        if key in party:
            current_dict[key] = group



parties = {
	"vert" : 'The Greens',

}


# Get Twitter profile photos based on links: https://api.twitter.com/1.1/users/show.json?screen_name=rsarver | key: profile_image_url_https
# Get Facebook profile photo based on link
# EOF
