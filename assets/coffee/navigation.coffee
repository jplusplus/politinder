#!/usr/bin/env coffee
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
window.polinder = {} unless window.polinder?

class polinder.Navigation

	constructor: ->
		@uis =
			landing_page           : $(".landing-page")
			landing_page_start_btn : $(".landing-page a.btn")

		# bind events
		@uis.landing_page_start_btn.on("click", @showSurvey)

	showSurvey: =>
		console.log "coucou"

# EOF
