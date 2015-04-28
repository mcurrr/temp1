window.jQuery = window.$ = require 'jquery'
require './bullet.js'

window.socket = $.bullet 'wss://www.favbet.com/bullet'

window.socket.onopen = ->
	console.log "window.socket opened"
	window.socket.send(JSON.stringify {user_ssid: "34537A49D03AEEF25FD3933AD6"})
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
	console.log "======================="
	eData = JSON.parse(e.data)
	sortMessage(eData)
	window.socket.send(JSON.stringify {
						dataop: {
							"live.event": ["all"]
						}
					})

sortMessage = (e) ->
	console.log e
	e.map (j, k) ->
		switch (j.type)
#outcomes changed
			when 'outcome.update_list' then output = ""
				#j.data.outcomes.map (out) -> out.market_id ==
			when 'outcome.update_result' then output = "#{j.type}"
#event changed
			when 'event.unsuspend' then output = "#{j.type}"
			when 'event.suspend' then output = ""
				#do nthg
			when 'event.update_result' then output = ""
				#do nthg
			when 'event.update' then =>
				output = ""
				if _.keys(j.data.event.head_market).length
					if j.data.event.event_tv_channel?
						#search in array
						j.data.event.can_be_shown = true
						events.push j.data
						console.log "UPDATE CHANNEL!"
#event can contain both of two params (channel & broadcast)
					else
						if j.data.event.event_broadcast_url?
							#search in array 
							j.data.event.can_be_shown = false
							events.push j.data
							console.log "UPDATE BROADCAST!"
#no outcomes - means it is statistic
				else
					console.log "statistic changed"
			when 'event.set_finished' then output = ""
				#do nthg
			when 'event.insert' then =>
				output = ""
				if _.keys(j.data.event.head_market).length
					if j.data.event.event_tv_channel?
						j.data.event.can_be_shown = true
						events.push j.data
						console.log "INSERT CHANNEL!"
#event can contain both of two params (channel & broadcast)
					else
						if j.data.event.event_broadcast_url?
							j.data.event.can_be_shown = false
							events.push j.data
							console.log "INSERT BROADCAST!"
#no outcomes - means it is statistic
				else
					console.log "statistic changed"
#market changed
			when 'market.insert_list' then output = "#{j.type}"
			when 'market.insert_list' then output = "#{j.type}"
			when 'market.unsuspend' then output = "#{j.type}"
			when 'market.delete' then output = "#{j.type}"
			when 'market.unsuspend_list' then output = "#{j.type}"
#smth else
			else output = "SMTH NEW!!! #{j.type}======!!!!!!!!!!======"
		console.log "#{k} #{output}"

module.exports = window.socket