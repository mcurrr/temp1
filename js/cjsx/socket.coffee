window.jQuery = window.$ = require 'jquery'
require './bullet.js'

window.socket = $.bullet 'wss://www.favbet.com/bullet'

window.socket.onopen = ->
	console.log "window.socket opened"
	window.socket.send(JSON.stringify {user_ssid: "DF296C9D6315480B23F0D40FA8"})
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

#====OUTCOMES====
			when 'outcome.update_list'
				window.output = "#{inCome.type}"
				inCome.data.outcomes.map (obj) -> 
					events.map (event) ->
						if obj.market_id == event.head_market.market_id
							event.head_market.outcomes.map (coef) ->
								if obj.outcome_id == coef.outcome_id
									coef.outcome_coef = obj.outcome_coef
									console.log "ACTION-----OUTCOME IN #{event.event_name} UPDATED"
									###
									SET STATE HERE									
									###
									window.App.setState(
										events: events
										)

			when 'outcome.update_result'
				console.log "<-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
				console.log inCome.data 
				window.output = "#{inCome.type}"
			
#====EVENTS====
			when 'event.unsuspend'
				window.output = "DO NTHG"
			
			when 'event.suspend'
				window.output = "DO NTHG"
				#do nthg
			
			when 'event.update_result'
				window.output = "DO NTHG"
				#do nthg
			
			when 'event.update'
				window.output = "#{inCome.type}"
				if _.keys(inCome.data.head_market).length
					if inCome.data.event_tv_channel?
						events.map (event) ->
							if event.event_id == inCome.data.event_id
								console.log "UPDATE CHANNEL IF YOU KNOW WHAT TO UPDATE!"
								return false
#no outcomes - means it is statistic
				else
					console.log "statistic changed"

			when 'event.set_finished'
				window.output = "event.set_finished DO NTHG"
				#do nthg

			when 'event.delete'
				console.log "deleted?"
				console.log inCome.data
				console.log window.App.state.events.length
				window.output = "#{inCome.type}"
				del = _.remove events, _.map events, (event) ->
					event.event_id == inCome.data.event_id
				console.log del.length
				if del.length
					console.log "WAS", window.App.state.events.length
					###
					SET STATE HERE									
					###
					window.App.setState(
						events: events
						)
					console.log "IS", window.App.state.events.length
					console.log "ACTION-=-=-=-=-#{del[0].event_name} DELETED!"
					
			when 'event.insert'
				if _.keys(inCome.data.head_market).length
					console.log window.App.state.events.length
					if inCome.data.event_tv_channel?
						inCome.data.new = true
						events.push inCome.data
						console.log "WAS", window.App.state.events.length
						###
						SET STATE HERE									
						###
						window.App.setState(
							events: events
							)
						console.log "IS", window.App.state.events.length
						console.log "ACTION-=-=-=-=-#{inCome.data.event_name} INSERT CHANNEL!"
#no outcomes - means it is statistic
				else
					console.log "statistic changed"

#====MARKETS====
			when 'market.insert_list'
				console.log "insert market <<<<<<<<<<<<<"
				console.log inCome.data

			when 'market.unsuspend'
				console.log "unsuspend market <<<<<<<<<<<<<<<<"
				console.log inCome.data

			when 'market.suspend'
				console.log "suspend market <<<<<<<<<<<<<<"
				console.log inCome.data

			when 'market.delete'
				console.log "delete market <<<<<<<<<<<<<<"
				console.log inCome.data

			when 'market.unsuspend_list'
				console.log "unsuspend_list market <<<<<<<<<<<<<<"
				console.log inCome.data

			when 'market.suspend_list'
				console.log "suspend_list market <<<<<<<<<<<<<"
				console.log inCome.data

#====ELSE====
			else window.output = "SMTH NEW!!! #{inCome.type}======!!!!!!!!!!======"
		events

module.exports = window.socket