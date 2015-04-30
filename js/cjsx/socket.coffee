window.jQuery = window.$ = require 'jquery'
require './bullet.js'

window.socket = $.bullet 'wss://www.favbet.com/bullet'

window.socket.onopen = ->
  console.log "window.socket opened"
  window.socket.send(JSON.stringify {user_ssid: "31E508294EC3DC7CE3A9EB8216"})
  window.socket.send(JSON.stringify {
            dataop: {
              "live.event": ["all"]
            }
          })
  
window.socket.ondisconnect = ->
  console.log "socket disconnect"
  
window.socket.onclose = ->
  console.log "socket closed"
  
window.socket.onmessage = (e) ->
  eData = JSON.parse(e.data)
  sortMessage(eData)
  window.socket.send(JSON.stringify {
            dataop: {
              "live.event": ["all"]
            }
          })

sortMessage = (e) ->
  e.map (inCome, k) ->
    switch (inCome.type)

#=================OUTCOMES

      when 'outcome.update_list'
        events = window.App.state.events
        inCome.data.outcomes.map (obj) -> 
          events.map (event) ->
            if obj.market_id == event.head_market.market_id
              event.head_market.outcomes.map (coef) ->
                if obj.outcome_id == coef.outcome_id
                  coef.outcome_coef = obj.outcome_coef
                  ###
                  SET STATE HERE                  
                  ###
                  window.App.setState(
                    events: events
                    )

      when 'outcome.update_result'
        console.log "<-=-=-=-=-=-=-=-=-=-=WHAT?-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
        console.log "#{inCome.type}"
        console.log inCome.data 
      
#===================EVENTS

      when 'event.unsuspend'
        events = window.App.state.events
        events.map (event) ->
          if event.event_id == inCome.data.event_id
            console.log "UNSUSPENDED EVENT #{event.event_name}!"
            event.suspended = false
            event.head_market.market_suspend = 'no'
            ###
            SET STATE HERE                  
            ###
            window.App.setState(
              events: events
              )
            false
      
      when 'event.suspend'
        events = window.App.state.events
        events.map (event) ->
          if event.event_id == inCome.data.event_id
            console.log "SUSPENDED EVENT #{event.event_name}!"
            event.suspended = true
            event.head_market.market_suspend = 'yes'
            false
      
      when 'event.update_result'
        false
      
      when 'event.update'
        console.log 'event.update? ALL'
        console.log inCome.data
        events = window.App.state.events
        events.map (event) ->
          if event.event_id == inCome.data.event_id
            console.log "UPDATE CHANNEL #{event.event_name} IF YOU KNOW WHAT TO UPDATE!"
            return false

      when 'event.set_finished'
        events = window.App.state.events
        events.map (event) ->
          if event.event_id == inCome.data.event_id
            console.log "FINISHED EVENT #{event.event_name}! RESULT: #{inCome.data.event_result_name}"
            event.finished = true
            ###
            SET STATE HERE                  
            ###
            window.App.setState(
              events: events
              )
            false

      when 'event.delete'
        window.output = "#{inCome.type}"
        events = window.App.state.events
        del = _.remove events, (event) ->
          event.event_id == inCome.data.event_id
        console.log "length of deleted", del.length
        if del.length
          console.log "WAS", events.length + del.length
          ###
          SET STATE HERE                  
          ###
          window.App.setState(
            events: events
            )
          console.log "IS", window.App.state.events.length
          console.log "ACTION-=-=-=-=-#{del[0].event_name} DELETED!"
          
      when 'event.insert'
        events = window.App.state.events
        if _.keys(inCome.data.head_market).length
          if inCome.data.event_tv_channel?
            inCome.data.new = true
            console.log "WAS", events.length
            events.push inCome.data
#sorting new array by the event name
            sortedEvents = _.sortBy events, 'event_name'
            ###
            SET STATE HERE                  
            ###
            window.App.setState(
              events: sortedEvents
              )
            console.log "IS", window.App.state.events.length
            console.log "ACTION-=-=-=-=-#{inCome.data.event_name} INSERT CHANNEL!"
#no outcomes - means it is statistic
        else
          console.log "statistic changed"

#================MARKETS

      when 'market.insert_list'
        console.log 'market.insert_list? ALL'
        console.log inCome.data
        events = window.App.state.events
        events.map (event) ->
          if event.event_id == inCome.data.event_id
            event.head_market = inCome.data
            console.log "market.insert_list #{event.event_name}"
            console.log inCome.data
            console.log event
            ###
            SET STATE HERE                  
            ###
            window.App.setState(
              events: events
              )
            false

      when 'market.unsuspend'
        events = window.App.state.events
        events.map (event) ->
          if event.event_id == inCome.data.event_id
            if event.head_market.market_id = inCome.data.market_id
              event.head_market.market_suspend = 'no'
              console.log "market.unsuspend #{event.event_name}"
              console.log inCome.data
              console.log event
              ###
              SET STATE HERE                  
              ###
              window.App.setState(
                events: events
                )
              false

      when 'market.suspend'
        events = window.App.state.events
        events.map (event) ->
          if event.event_id == inCome.data.event_id
            if event.head_market.market_id = inCome.data.market_id
              event.head_market.market_suspend = 'yes'
              console.log "market.suspend #{event.event_name}"
              console.log inCome.data
              console.log event
              ###
              SET STATE HERE                  
              ###
              window.App.setState(
                events: events
                )
              false

      when 'market.delete'
        events = window.App.state.events
        events.map (event) ->
          if event.event_id == inCome.data.event_id
            if event.head_market.market_id = inCome.data.market_id
              event.head_market = {}
              console.log "market.delete #{event.event_name}"
              console.log inCome.data
              console.log event
              ###
              SET STATE HERE                  
              ###
              window.App.setState(
                events: events
                )
              false

      when 'market.unsuspend_list'
        events = window.App.state.events
        events.map (event) ->
          if event.event_id == inCome.data.event_id
            if event.head_market.market_id = inCome.data.market_id
              event.head_market.market_suspend = 'no'
              console.log "market.unsuspend_list #{event.event_name}"
              console.log inCome.data
              console.log event
              ###
              SET STATE HERE                  
              ###
              window.App.setState(
                events: events
                )
              false

      when 'market.suspend_list'
        events = window.App.state.events
        events.map (event) ->
          if event.event_id == inCome.data.event_id
            if event.head_market.market_id = inCome.data.market_id
              event.head_market.market_suspend = 'yes'
              console.log "market.suspend_list #{event.event_name}"
              console.log inCome.data
              console.log event
              ###
              SET STATE HERE                  
              ###
              window.App.setState(
                events: events
                )
              false

      else window.output = "SMTH NEW!!! #{inCome.type}======!!!!!!!!!!======"
    events

module.exports = window.socket