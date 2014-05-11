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

import json
import csv

	
parties = json.load(open("parties.json"))
candidats = json.load(open("dump.json"))
candidats = filter(lambda _: "picture" in _, candidats)
questions = open("matches.csv", "rb")
questions = list(csv.DictReader(questions))

def get_match(name):
	for key, value in parties.items():
		if key.lower() in name.lower():
			return value

results = []
for c in candidats:
	eu_party = get_match(c['party'])
	if eu_party:
		c["eu_party"] = eu_party
		c["answers"] = {}
		for r in questions:
			if r[c["eu_party"]] != "":
				c["answers"][r["slug"]] = r[c["eu_party"]] == "true"
		results.append(c)

print json.dumps(results)
