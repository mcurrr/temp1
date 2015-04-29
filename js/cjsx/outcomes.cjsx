React = require('react')

Outcomes = React.createClass
	displayName: 'Outcomes'

	render: ->
		<div className='outcomes' style={"position": "absolute", "color": "#fff"}>
			<ul>{
				if @props.current.i? && @props.events[@props.current.i].head_market.outcomes?
					@props.events[@props.current.i].head_market.outcomes.map (outcome, i) =>
						<li className='outcome' key={i}><span>{
							"#{outcome.outcome_name} #{outcome.outcome_coef}"
						}</span></li>
			}
			</ul>
		</div>

module.exports = Outcomes
