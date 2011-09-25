html ->
  head ->
    title 'Karel Learns JavaScript'
    link rel: 'stylesheet', href: 'css/style.css', type: 'text/css'
    script type: 'text/javascript', src: 'lib/util.js'
    script type: 'text/javascript', src: 'lib/point.js'
    script type: 'text/javascript', src: 'lib/circle.js'
    script type: 'text/javascript', src: '../codeMirror/js/codemirror.js'
    script type: 'text/javascript', src: 'js/karel.js'
    script type: 'text/javascript', src: 'js/beepers.js'
    script type: 'text/javascript', src: 'js/walls.js'
    script type: 'text/javascript', src: 'js/karelWorld.js'
    script type: 'text/javascript', src: 'js/karelApplication.js'
    script type: 'text/javascript', src: 'js/application.js'
    div id: 'header', ->
      div id: 'inner', ->
        a id: 'logo', href: '', rel: 'nofollow', 'Open Classroom'
        div id: 'smallLinks', ->
          a id: 'smallLink', href: 'materials/karellearnsJava.pdf', rel: 'nofollow', 'Book'
          a id: 'smallLink', href: 'about.html', rel: 'nofollow', 'About'
  body ->
    div id: 'content', ->
      div id: 'buttonBar', ->
        form ->
          text 'Start:'
          input id: 'interactor', type: 'button', value: 'Run', onClick: 'application.runButton()'
          text '&nbsp;&nbsp;\n\t\t\t\t\tWorld:'
          select id: 'interactor', name: 'world', size: '0', onChange: 'application.changeWorld(this)', ->
            option value: '1', ->
              text '15x15.w'
              # option value: '1', ->
              #   text '12x12.w'
              #   option value: '2', ->
              #     text '9x9.w'
              #     option value: '2', ->
              #       text '8x2.w'
              #       option value: '2', ->
              #         text '1x6.w'
              #         option value: '3', ->
              #           text '4x4.w'
              #           option value: '3', ->
              #             text '1x1.w'
              #             option value: '4', ->
              #               text 'large.w'
              #               option value: '4', ->
              #                 text 'collectNewspaper.w'
              #                 option value: '5', ->
              #                   text 'pothole.w'
              #                   option value: '5', ->
              #                     text 'maze.w'
              #                     option value: '6', ->
              #                       text 'line.w'
              #                       option value: '7', ->
              #                         text 'cleanUp.w'
              #                         option value: '8', 'columns.w'
          comment '-&nbsp;&nbsp;\n\t\t\t\t\tFile:\n\t\t\t\t\t<input type=\'button\' value=\'Save\' id=\'interactor\'\n\t\t\t\t\t\tonClick=\'application.saveButton()\'>\n\t\t\t\t\t<input type=\'button\' value=\'Load\' id=\'interactor\'\n\t\t\t\t\t\tonClick=\'application.saveButton()\'>'
      textarea id: 'code', name: 'code', '//write your karel javascript\n//code here.\n\nfunction run() {\n\n}'
      canvas id: 'canvas', name: 'canvas'
