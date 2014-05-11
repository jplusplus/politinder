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
			game_over              : $(".game-over")
			modal                  : $("#match-modal")
			informations           : $(".informations")
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
		queue()
			.defer(d3.json, 'static/data/questions.json')
			.defer(d3.json, 'static/data/candidates.json')
			.await(@renderPanels)
		# put the first one as current slide
		@currentSlide = @uis.slide_container.find(".slide:not(.template):not(.informations)").last()

	renderPanels: (a, questions, candidates) =>
		@questions  = questions[...3]
		@candidates = _.shuffle(candidates)
		@renderSurvey()
		@renderMatcher()

	renderSurvey: =>
		nuis_to_append = []
		for question in @questions
			panel = new polinder.Question(question, @polinder)
			nuis_to_append.push(panel.getUi())
		# add to view
		@uis.question_intro.before(nuis_to_append)

	renderMatcher: (count=3) =>
		nuis_to_append = []
		i = 0
		while @candidates.length > 0 and i < count
		# for candidate in @candidates[0...count]
			candidate = @candidates.pop()
			panel = new polinder.Matcher(candidate, @polinder)
			nuis_to_append.push(panel.getUi())
			i += 1
		# add to view
		@uis.game_over.after(nuis_to_append)

	# -----------------------------------------------------------------------------
	# EVENTS HANDLER
	nextSlide: (e, exit) =>
		# laod a new slide if in tinder mode
		@renderMatcher(1) if @currentSlide.hasClass("matcher")	
		# remove the previous slide, show the next one
		# @currentSlide.remove()
		if exit == "right"
			@currentSlide.addClass("disapear--right") 
		else
			@currentSlide.addClass("disapear")
		setTimeout(=>
			@currentSlide.remove()
			@currentSlide = @uis.slide_container.find(".slide:not(.template):not(.informations)").last()
		, 350)

	onMatch: (e, candidate) =>
		# show the modal view, connect the button
		@uis.modal.find(".candidate__name").html(candidate.name)
		@uis.modal.modal("show")
		# bind modal view event
		@uis.modal.find(".yes").on "click", =>
			@showCandidateInfo(candidate)()
			@uis.modal.modal("hide")

	showCandidateInfo: (candidate) =>
		that = this
		if candidate
			return ->
				body = ""
				fields = 
					name : "name"
					country : "country"
					region : "region"
					party : "party"
				for key, value of fields
					body += "<dt>#{value}</dt><dd>#{candidate[key]}</dd>" if candidate[key]? and candidate[key] != ""
				that.uis.informations.find("dl").html(body)
				that.uis.informations.find(".illustration").css("background-image", "url(static/#{candidate.picture})")
				that.uis.informations.removeClass("hidden")
				# back button 
				that.uis.informations.find("a").on "click", ->
					that.uis.informations.addClass("hidden")

class polinder.Panel
	@TEMPLATE = $(".Panel.template")
	constructor: ->
		# bind events
		@ui.find("a.btn").on "click", @onUserChoice
	onUserChoice: (exit="left") => $(document).trigger("nextSlide", [exit])
	getUi       : => return @ui
	hide        : =>
		@ui.css("top")

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
		super("right" if $(e.currentTarget).hasClass("yes"))

class polinder.Matcher extends polinder.Panel

	constructor: (candidate, _polinder) ->
		that       = this
		@polinder  = _polinder
		@candidate = candidate
		# create a UI element
		@ui = polinder.Panel.TEMPLATE.clone().removeClass("template").addClass("actual matcher")
		# feel the content
		@ui.find(".name").html(candidate.quote)
		@ui.find(".question").remove()
		@ui.find(".illustration").css("background-image", "url(static/#{candidate.picture})")
		super

	onUserChoice: (e) =>
		if $(e.currentTarget).hasClass("yes")
			super("right")
			if @polinder.isMatching(@candidate)
				$(document).trigger("onMatch", [@candidate])
			return
		return super("left")

class polinder.Polinder
	constructor: ->
		@answers = {}
	
	setChoice: (question_slug, answer) =>
		@answers[question_slug] = answer

	isMatching: (candidate) =>
		score = 0
		for key, value of @answers
			if candidate.answers[key]? and candidate.answers[key] == value
				score += 1
		base = Math.min(_.size(candidate.answers), _.size(@answers))
		return score/base > .8

# EOF
