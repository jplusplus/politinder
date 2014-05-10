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
	"https://politicsforpeople.eu/sweden/"
]

for page in PAGES:
	r        = requests.get(page)
	document = html.fromstring(r.content)
	lines    = document.cssselect('.ginput_container li')
	for line in lines:
		entry = {
			"links" : {},
			"name"  : line.find("label").text           if line.find("label") != None else "",
			"party" : line.find_class("party")[0].text  if line.find_class("party")   else "",
			"region": line.find_class("region")[0].text if line.find_class("region")  else "",
		}
		for link in line.findall("a"):
			link = link.attrib["href"]
			if "twitter"    in link: entry["links"]["twitter"]  = link
			elif "facebook" in link: entry["links"]["facebook"] = link
		if "twitter" in entry["links"] or "facebook" in entry["links"]:
			pass
		pp(entry)

# EOF
