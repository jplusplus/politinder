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

from flask import Flask, render_template, request, send_file, g, \
	send_from_directory, Response, abort, session, redirect, url_for, make_response
from flask.ext.assets import Environment, YAMLLoader

# app & settings
app = Flask(__name__)
app.config.from_pyfile("settings.cfg")
# assets manager
assets  = Environment(app)
bundles = YAMLLoader("assets.yaml").load_bundles()
assets.register(bundles)

# -----------------------------------------------------------------------------
#
# Site pages
#
# -----------------------------------------------------------------------------
@app.route('/')
def index():
	response = make_response(render_template('home.html'))
	return response

# -----------------------------------------------------------------------------
#
# Main
#
# -----------------------------------------------------------------------------
if __name__ == '__main__':
	# run application
	app.run(extra_files=("assets.yaml",), host="0.0.0.0")

# EOF
