React = require('react')

List = React.createClass
	displayName: 'List'

	render: ->
		<div className='col-sm-4'>
			<ul>{
				@props.events.map (event, i) =>
					if @props.current.i == i #if active
						if event.new
							style = 'btn btn-block btn-danger'
							newWord = 'new! '
						else
							style = 'btn btn-block btn-primary'
							newWord = ''
					else 
						if event.new
							style = 'btn btn-block btn-success'
							newWord = 'new! '
						else
							style = 'btn btn-block btn-info'
							newWord = ''
					<li onClick={@props.show.bind null, i} key={i}><a href="#" onclick="event.preventDefault();" className={style} style={{"overflow": "hidden", "textOverflow": "ellipsis"}}>{
						"#{i+1} #{newWord} #{event.event_name}"
						}</a></li>
			}
			</ul>
		</div>

module.exports = List