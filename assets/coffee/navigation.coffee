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
			info_pages             : $(".info-page")
			slide_container        : $(".slide-container")

		# FIXME: just for debug, to be removed
		(console.warn("NAVIGATION :: @uis.#{key} is empty") unless nui.length > 0) for key, nui of @uis

		@currentSlide    = undefined

		@init()

		# bind events
		@uis.info_pages.find("a.btn").on("click", @nextSlide)
		$(document).on("nextSlide", @nextSlide)

	init: =>
		@polinder = new polinder.Polinder()
		@renderSurvey()
		# put the first one as current slide
		@currentSlide = @uis.slide_container.find(".slide:not(.template)").first()

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
		for question in questions
			# # clone the panel template
			panel = new polinder.Question(question, @polinder)
			nuis_to_append.push(panel.getUi())
		# add to view
		@uis.slide_container.append(nuis_to_append)

	nextSlide: =>
		@currentSlide.remove()
		@currentSlide = @uis.slide_container.find(".slide:not(.template)").first()

class polinder.Panel
	
	@TEMPLATE = $(".panel.template")

	constructor: ->
		# bind events
		@ui.find("a.btn").on "click", @onUserChoice

	onUserChoice: =>
		$(document).trigger("nextSlide")

	getUi: => return @ui

class polinder.Question extends polinder.Panel

	constructor: (question, polinder_) ->
		that      = this
		@question = question
		@polinder = polinder_
		# create a UI element
		@ui = polinder.Panel.TEMPLATE.clone().removeClass("template").addClass("actual question")
		# feel the content
		@ui.find(".question").html(question.quote)
		@ui.find(".illustration").css("background-image", "url(static/#{question.picture})")
		super

	onUserChoice: (e) =>
		# save the answer
		@polinder.setChoice(@question.slug, $(e.currentTarget).hasClass("yes"))
		super

class polinder.Polinder
	constructor: ->	@answers = {}
	setChoice: (question_slug, answer) =>
		@answers[question_slug] = answer
		console.log @answers

# EOF
