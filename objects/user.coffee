events = require 'events'

class User extends events.EventEmitter

  constructor: (@socket) ->
    @id = @socket.id

    @socket.on 'disconnect', ->
      @parent = undefined
      this.emit 'disconnect'

    @parent = undefined
