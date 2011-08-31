doctype 5
html ->
  head ->
    title 'Page Title'
    # link rel: 'stylesheet', href: 'http://code.jquery.com/mobile/1.0b1/jquery.mobile-1.0b1.min.css'
    # script type: 'text/javascript', src: 'http://code.jquery.com/jquery-1.6.1.min.js'
    # script type: 'text/javascript', src: 'http://code.jquery.com/mobile/1.0b1/jquery.mobile-1.0b1.min.js'

    script src: '/env.js'
    script src: '/socket.io/socket.io.js'

  body ->
    div 'data-role': 'page', ->
      div 'data-role': 'header', ->
        h1 'Page Title'
      comment '/header'
      div 'data-role': 'content', ->
        h2 id: 'question', 'Question'
        ul 'data-role': 'listview', 'data-theme': 'g', 'data-inset': 'true', ->
          li ->
            a id: 'one', href: 'javascript:window.socket.emit(\'answer\',1)', 'Acura'
        ul 'data-role': 'listview', 'data-theme': 'g', 'data-inset': 'true', ->
          li ->
            a id: 'two', href: 'javascript:window.socket.emit(\'answer\',2)', 'Audi'
        ul 'data-role': 'listview', 'data-theme': 'g', 'data-inset': 'true', ->
          li ->
            a id: 'three', href: 'javascript:window.socket.emit(\'answer\',3)', 'BMW'
        ul 'data-role': 'listview', 'data-theme': 'g', 'data-inset': 'true', ->
          li ->
            a id: 'four', href: 'javascript:window.socket.emit(\'answer\',4)', 'BMW'
      comment '/content'
      div 'data-role': 'footer', ->
        h4 'Page Footer'
      comment '/footer'
    comment '/page'


    coffeescript ->
      # $(document).ready ->
      socket = io.connect "http://#{window.trivia_host}:#{window.trivia_port}"
      socket.on 'connect', ->
        socket.emit 'contestant'
          # socket.emit 'contestant', gameId: @gameId
          # socket.on 'response', (correct) ->
          #   if correct alert 'correct'
          #   else alert 'incorrect'
          # socket.on 'data', (data) ->
          #   console.log "data: #{data}"

          #   document.getElementById('question').innerHTML = data.question
          #   document.getElementById('one').innerHTML = data.q1
          #   document.getElementById('two').innerHTML = data.q2
          #   document.getElementById('three').innerHTML = data.q3
          #   document.getElementById('four').innerHTML = data.q4

