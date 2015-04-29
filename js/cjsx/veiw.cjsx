React = require('react')
List = require './list.cjsx'
Video = require './video.cjsx'
Outcomes = require './outcomes.cjsx'

View = React.createClass
	displayName: 'View'

	render: ->
		<div className='container'>
			<div className='row' style={'position': 'relative'}>
				<List
					events={@props.events}
					current={@props.current}
					show={@props.show}
					/>
					<Video						
						current={_.cloneDeep @props.current}
						/>
					<Outcomes
						current={@props.current}
						events={@props.events}
					/>
			</div>
		</div>

module.exports = View