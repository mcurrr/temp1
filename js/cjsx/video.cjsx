React = require('react')
window.player = require './player.coffee'

Video = React.createClass
  displayName: 'Video'
  shouldComponentUpdate: (nextProps, nextState) ->
     nextProps.current.url isnt @props.current.url

  componentDidUpdate: (prevProps, prevState) ->
    if !!@props.current.url
      if player.exist()
        player.deleteVideo()
      @refs.target.getDOMNode().innerHTML = "<video id='favbet-tv-video' class='video-js vjs-default-skin' width='100%' height='100%'><source src='" + @props.current.url + "' type='rtmp/flv' /><p className='vjs-no-js'>To view this video please enable JavaScript, and consider upgrading to a web browser that <a href='http://videojs.com/html5-video-support/' target='_blank'>supports HTML5 video</a></p></video>"
#play the videoStream with current url
      player.initVideo()
    else
      if player.exist()
        player.deleteVideo()

  render: ->
    <div className='col-sm-8' ref="target"/>

module.exports = Video