React = require 'react'
View = require './veiw.cjsx'
player = require './player.coffee'
socket = require './socket.coffee'
$ = require 'jquery'
_ = require 'lodash'


App = React.createClass
  displayName: 'App'

  getInitialState: ->
    {
      events: []
      current: {
        url: ''
      }
    }

  propTypes:
    events: React.PropTypes.array.isRequired
    current: React.PropTypes.object
    url: React.PropTypes.string

  componentWillMount: ->
    player.init()
#get the list of all live events
    $.ajax
      url: 'https://www.favbet.com/live/markets/'
      cache: false
      dataType: 'json'
      error: (xhr, ajaxOptions, thrownError) ->
        console.log 'error on first request'
        console.log xhr.status
        console.log thrownError
      success: (data) =>
        window.events = []
        window.live = 0
        window.channel = 0
        window.broadcast = 0
        window.statistic = 0
        sportCollection = data.markets
        console.log sportCollection
        _.map sportCollection, (sport) ->
          _.map sport.tournaments, (tournament) ->
            tournament.events.map (event, i) ->
#in case invalid event
              if event.event_name
                live++
#TODO: figure out how to separate actual event from it's own statistic (use event_dt, event_name, head_market)
                if event.event_tv_channel?
                  #do we have the same event in the array already (statistic)?
                  res = _.result _.find events, (old) ->
                    old.event_name == event.event_name
                  if res
                    #it's a statistic
                    console.log "statistic!", event.event_name
                  else
                    #it's not a statistic
                    channel++
                    events.push event
                    console.log "unique event: ", event.event_name

        console.log "#{live} live events + #{statistic} channel statistics"
        console.log "#{channel} live events with video stream"
        console.log events
        @setState(
          events: events 
        )

  handlerShowingVideo: (i) ->
    if i != @state.current.i
      current = @state.current
      current.i = i
      @setState(
        current: current 
        )
      @_deleteFinished()
#get the video stream number of current event
      $.ajax
        url: "https://www.favbet.com/live/markets/event/#{@state.events[i].event_id}/"
        cache: false
        dataType: 'json'
        error: (xhr, ajaxOptions, thrownError) ->
          console.log xhr.status
          console.log thrownError
        success: (data) =>
          current.id_tv = data.event_tv_channel
          @setState(
            current: current
          )
          @_getVideoStreamPath()

  _deleteFinished: () ->
    _.remove events, (event) ->
      if event.finished?
        console.log "REMOVING FINISHED #{event.event_name}================="
        true
      else
        false
    @setState(
          events: events
        )


  _getVideoStreamPath: () ->
#get current id_tv
    $.ajax
      url: "https://www.favbet.com/live/tv/#{@state.current.id_tv}/"
      cache: false
      dataType: 'xml'
      error: (xhr, ajaxOptions, thrownError) ->
        console.log xhr.status
        console.log thrownError
      success: (data) =>
#get URL from XML of stream
        url = $(data).find('stream').attr('request_stream')
        if !url
          error = $(data).find('streams').attr('error')
          url = ''
          current = @state.current
          current.url = url
          @setState(
            current: current 
          )
          console.log "error in XML: #{error}"
          console.log @state.current.url
        else
  #decoding url with regexp
          url = url.replace /%3A/g, ':'
          url = url.replace /%2F/g, '/'
          url = url.replace /%3F/g, '?'
          url = url.replace /%3D/g, '='
          url = url.replace /%26/g, '&'
          if url.match /^http/
            console.log "MATCH!"
            $.ajax
              url: url
              cache: false
              dataType: 'xml'
              error: (xhr, ajaxOptions, thrownError) ->
                console.log xhr.status
                console.log thrownError
              success: (data) =>
  #get URL from XML of stream
                console.log data
  #assembling url parts
                urlUrl = $(data).find('token').attr('url')
                urlStream = $(data).find('token').attr('stream')
                urlAuth = $(data).find('token').attr('auth')
  #final url
                url = "rtmp://#{urlUrl}:#{urlStream}"
                current = @state.current
                current.url = url
                @setState(
                  current: current 
                )
                console.log "@state ajax url: #{@state.url}"
                console.log "stream with autentication, NOT able to show"
          else
            current = @state.current
            current.url = url
            @setState(
              current: current 
            )

  render: ->
    <View
      show={@handlerShowingVideo}
      events={@state.events}
      current={@state.current}
    />

window.App = React.render(<App/>, document.getElementById('main'))