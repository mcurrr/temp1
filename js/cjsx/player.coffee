module.exports = 
  init: ->
    window.isPlayerExist = false

  exist: ->
    window.isPlayerExist

  initVideo: ->
    setTimeout (->
      window.isPlayerExist = true
      window.innerPlayer = videojs("favbet-tv-video", {
        "controls": true,
        "bigPlayButton": false 
        "autoplay": false,
        "preload": "metadata",
        "poster": "https://www.favbet.com/static/themes/1/img/logo.png?v=1"
      })
      innerPlayer.play()
#if volume was previously changed then set it for new player
      if window.realVolume?
        innerPlayer.volume(window.realVolume)
      innerPlayer.on 'pause', ->
        console.log "paused?:", innerPlayer.paused()
        innerPlayer.one 'play', ->
          console.log "paused?:", innerPlayer.paused()
          player.unPauseVideo()
      innerPlayer.on 'volumechange', ->
        window.realVolume = innerPlayer.volume()
    ), 100

  deleteVideo: ->
    window.isPlayerExist = false
    innerPlayer.dispose()

#KOSTIL'?
  unPauseVideo: ->
#forcing to update player by triggering react with changing url in state
    current = window.App.state.current
    oldCurrent = current.url
    current.url = ''
    window.App.setState(
      current: current
    )
#    console.log "empty url: ", window.App.state.current.url
    current.url = oldCurrent
    window.App.setState(
      current: current
    )
#    console.log "old url: ", window.App.state.current.url
