module.exports = 
  init: ->
    window.isPlayerExist = false

  exist: ->
    window.isPlayerExist

  initVideo: ->
    setTimeout (->
      window.isPlayerExist = true
      window.innerPlayer = videojs("favbet-tv-video", {
        "controls": true
        "children":
          "controlBar":
            "children":
              "currentTimeDisplay": false
              "timeDivider": false
              "durationDisplay": false
              "liveDisplay": true
        "bigPlayButton": false
        "autoplay": false
        "preload": "metadata"
        "poster": "https://www.favbet.com/static/themes/1/img/logo.png?v=1"
        "playbackRates": [0.5, 1, 1.5, 2]
      })
      innerPlayer.play()
#if volume was previously changed then set it for new player
      if window.realVolume?
        innerPlayer.volume(window.realVolume)
      innerPlayer.on 'pause', ->
        console.log "paused?:", innerPlayer.paused()
        innerPlayer.one 'play', ->
          console.log "paused?:", innerPlayer.paused()
          console.log "buffered start:", innerPlayer.buffered().start()
          console.log "buffered end:", innerPlayer.buffered().end()
          console.log "buffered percent:", innerPlayer.bufferedPercent()
          player.unPauseVideo()
      innerPlayer.on 'volumechange', ->
        window.realVolume = innerPlayer.volume()
      innerPlayer.on 'loadstart', ->
        console.log "start"
        setInterval (->
          if innerPlayer.bufferedPercent() != 1 && innerPlayer.bufferedPercent() != 0
            console.log "loadeddata:", innerPlayer.bufferedPercent()
        ), 500

      innerPlayer.on 'loadedalldata', ->
        console.log "finily loadedalldata:", innerPlayer.bufferedPercent()
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
