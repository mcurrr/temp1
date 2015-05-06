module.exports = 
	init: ->
		window.isPlayerExist = false

	exist: ->
		window.isPlayerExist

	initVideo: ->
		setTimeout (->
			window.isPlayerExist = true
			videojs("favbet-tv-video", {
				"controls": true,
				"bigPlayButton": false 
				"autoplay": false,
				"preload": "metadata",
				"poster": "https://www.favbet.com/static/themes/1/img/logo.png?v=1"
			}).play()
		), 100

	deleteVideo: ->
		window.isPlayerExist = false
		videojs("favbet-tv-video").dispose()
