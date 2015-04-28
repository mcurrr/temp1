React = require('react')

Outcomes = React.createClass
	displayName: 'Outcomes'

	render: ->
		<div className='outcomes' style={"position": "absolute", "color": "#fff"}>
			<ul>{
				@props.current.outcomes?.map (outcome, i) =>
					<li className='outcome' key={i}><span>{
						"#{outcome.outcome_name} #{outcome.outcome_coef}"
						}</span></li>
			}
			</ul>
		</div>

module.exports = Outcomes
