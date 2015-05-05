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
        i: null
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
        sortedEvents = _.sortBy events, 'event_name'
        @setState(
          events: sortedEvents 
        )

  handlerShowingVideo: (i) ->
    @_deleteFinished()
    if i != @state.current.i
#setting @state.current in @_makeItActive
      @_makeItActive(i)
      @_deleteNewWord(i)
#get the video stream number of current event
      $.ajax
        url: "https://www.favbet.com/live/markets/event/#{@state.events[i].event_id}/"
        cache: false
        dataType: 'json'
        error: (xhr, ajaxOptions, thrownError) ->
          console.log xhr.status
          console.log thrownError
        success: (data) =>
          current = @state.current
          current.id_tv = data.event_tv_channel
          @setState(
            current: current
          )
          @_getVideoStreamPath()

  _makeItActive: (i) ->
    events = @state.events
    events.map (event) ->
      if event.active?
        delete event.active
    events[i].active = true
    current = @state.current
    actElem = _.find events, (event) ->
      !!event.active
#setting current.i that way because of new events incoming
    current.i = _.indexOf events, actElem
    console.log "active event", current.i
    @setState(
      current: current 
      )

  _deleteNewWord: (i) ->
    events = @state.events
    if !!events[i].new
      events[i].new = false
    @setState(
          events: events
        )

  _deleteFinished: () ->
    events = @state.events
    console.log "BEFORE DELETING FINISHED", events
    _.remove events, (event) ->
      !!event.finished
    console.log "AFTER DELETING FINISHED", events
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
            $.ajax
              url: url
              cache: false
              dataType: 'xml'
              error: (xhr, ajaxOptions, thrownError) ->
                console.log xhr.status
                console.log thrownError
              success: (data) =>
  #get URL from XML of stream, assembling url parts
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