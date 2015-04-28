React = require('react')

List = React.createClass
	displayName: 'List'

	render: ->
		<div className='col-sm-4'>
			<ul>{
				@props.events.map (event, i) =>
					if @props.current.i == i 
						if event.can_be_shown
							style = 'btn btn-block btn-primary'
						else
							style = 'btn btn-block btn-danger'
					else 
						if event.can_be_shown
							style = 'btn btn-block btn-info'
						else
							style = 'btn btn-block btn-warning'
					<li onClick={@props.show.bind null, i} key={i}><a href="#" onclick="event.preventDefault();" className={style} style={{"overflow": "hidden", "textOverflow": "ellipsis"}}>{
						"#{i+1} #{event.event_name}"
						}</a></li>
			}
			</ul>
		</div>

module.exports = List