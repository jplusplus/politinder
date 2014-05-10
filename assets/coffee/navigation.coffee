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
			question_intro         : $(".questions-intro")
			matcher_intro          : $(".matcher-intro")
			modal                  : $("#match-modal")
		# FIXME: just for debug, to be removed
		(console.warn("NAVIGATION :: @uis.#{key} is empty") unless nui.length > 0) for key, nui of @uis

		@currentSlide    = undefined

		@init()

		# bind events
		@uis.info_pages.find("a.btn").on("click", @nextSlide)
		$(document).on("nextSlide", @nextSlide)
		$(document).on("onMatch"  , @onMatch)

	init: =>
		@polinder = new polinder.Polinder()
		@renderSurvey()
		@renderMatcher()
		# put the first one as current slide
		@currentSlide = @uis.slide_container.find(".slide:not(.template)").first()

	renderSurvey: =>
		that           = this
		nuis_to_append = []
		questions      = [
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
			panel = new polinder.Question(question, @polinder)
			nuis_to_append.push(panel.getUi())
		# add to view
		@uis.question_intro.after(nuis_to_append)

	renderMatcher: (start=0, count=3) =>
		nuis_to_append = []
		candidates = [
			{
				name    : "Bob Dylan"
				picture : "pics/test.jpg"
			}
		]
		for candidate in candidates
			panel = new polinder.Matcher(candidate, @polinder)
			nuis_to_append.push(panel.getUi())
		# add to view
		@uis.matcher_intro.after(nuis_to_append)

	# -----------------------------------------------------------------------------
	# EVENTS HANDLER
	nextSlide: =>
		# remove the previous slide, show the next one
		@currentSlide.remove()
		@currentSlide = @uis.slide_container.find(".slide:not(.template)").first()

	onMatch: (e, candidate) =>
		# show the modal view, connect the button
		@uis.modal.find(".candidate__name").html(candidate.name)
		@uis.modal.find(".yes").on("click", @showCandidateInfo(candidate))
		@uis.modal.modal("show")

	showCandidateInfo: (candidate) =>
		if candidate
			return ->
				console.log "show info for ", candidate

class polinder.Panel
	@TEMPLATE = $(".panel.template")
	constructor: ->
		# bind events
		@ui.find("a.btn").on "click", @onUserChoice
	onUserChoice: => $(document).trigger("nextSlide")
	getUi       : => return @ui

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

class polinder.Matcher extends polinder.Panel

	constructor: (candidate, _polinder) ->
		that      = this
		@polinder = _polinder
		@candidate = candidate
		# create a UI element
		@ui = polinder.Panel.TEMPLATE.clone().removeClass("template").addClass("actual matcher")
		# feel the content
		@ui.find(".name").html(candidate.quote)
		@ui.find(".illustration").css("background-image", "url(static/#{candidate.picture})")
		super

	onUserChoice: (e) =>
		# save the answer
		if @polinder.isMatching(@candidate)
			$(document).trigger("onMatch", [@candidate])
		super

class polinder.Polinder
	constructor: ->
		@answers = {}
	
	setChoice: (question_slug, answer) =>
		@answers[question_slug] = answer

	isMatching: =>
		return true

# EOF
