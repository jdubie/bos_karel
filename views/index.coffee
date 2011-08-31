doctype 5
html ->
  head ->
    # link href: 'stylesheets/style.css', rel: 'stylesheet', type: 'text/css'

    link rel: 'stylesheet', type: 'text/css', href: 'stylesheets/jquery-ui.css'
    script type: 'text/javascript', src: 'javascripts/jquery.min.js'
    script type: 'text/javascript', src: 'javascripts/jquery-ui.min.js'

    script type: 'text/javascript', src: 'javascripts/mustache.js'
    script type: 'text/javascript', src: 'javascripts/underscore.js'
    script type: 'text/javascript', src: 'javascripts/backbone.js'
    script type: 'text/javascript', src: '/socket.io/socket.io.js'

    script type: 'text/javascript', src: 'javascripts/d3.js'
    script type: 'text/javascript', src: 'javascripts/d3.layout.js'

    script type: 'text/javascript', src: '/env.js'

    coffeescript ->
      $(document).ready ->

        # Profile = Backbone.Model.extend

        socket = io.connect "http://#{window.trivia_host}:#{window.trivia_port}"
        socket.on 'connect'
          socket.emit 'master'


  body ->
    div id: 'sidebar', ->
      h1 id: 'join', 'Join the Next Game'
      h1 id: 'link', ->
        text 'Go to:'
        br
        text 'http://trivia.com/peter-piper'
        br
        text 'on your smart phone'
      br
      a id: 'loggedin', 'Players logged in: #'
    div id: 'content', ->
      h1 id: 'question', 'Question 1'
      h1 id: 'questiontext', 'You lookin\' at me?  You lookin\' at me?'
      ul ->
        li id: 'a', ->
          h1 'Choice A'
        li id: 'b', ->
          h1 'Choice B'
        li id: 'c', ->
          h1 'Choice C'
        li id: 'd', ->
          h1 'Choice D'
    div id: 'rightside', ->
      h1 'Players Left:'
