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
			landing_page           : $(".info-page")
			landing_page_start_btn : $(".info-page a.btn")
			panel_tmpl             : $(".Panel.template")
			panel_container        : $(".panel-container")

		# FIXME: to be removed, just for debug
		(console.warn("NAVIGATION :: @uis.#{key} is empty") unless nui.length > 0) for key, nui of @uis

		@surveyResponses = {}
		@currentPanel    = undefined

		@init()

		# bind events
		@uis.landing_page_start_btn.on("click", @hideLandingPage)

	init: =>
		@renderSurvey()
		# put the first one as current panel
		@currentPanel = @uis.panel_container.find(".Panel.actual").first()

	hideLandingPage: =>
		@uis.landing_page.hide()

	renderSurvey: =>
		that = this
		nuis_to_append = []
		questions = [
			{
				slug    : "guerre"
				picture : "pics/test.jpg"
				quote   : "J'aime pas la guerre"
			}
			{
				slug    : "enfant"
				picture : "pics/test.jpg"
				quote   : "J'aime pas les enfants"
			}
		]
		# remove previous panel
		@uis.panel_container.find(".Panel.actual").remove()
		for question in questions
			# clone the panel template
			nui = @uis.panel_tmpl.clone().removeClass("template").addClass("actual question")
			# feel the content
			nui.find(".question").html(question.quote)
			nui.find(".illustration").css("background-image", "url(static/#{question.picture})")
			# bind events
			nui.find("a.btn").on "click", ((question) ->
				# save response, associated to the question
				return ->
					that.surveyResponses[question.slug] = $(this).hasClass("yes")
					that.nextPanel()
			)(question)
			nuis_to_append.push(nui)
		# add to view
		@uis.panel_container.append(nuis_to_append)

	nextPanel: =>
		@currentPanel.remove()
		@currentPanel = @uis.panel_container.find(".Panel.actual").first()

# EOF
