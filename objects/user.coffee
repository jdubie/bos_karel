events = require 'events'

class User extends events.EventEmitter

  constructor: (@socket) ->
    @id = @socket.id

    # bubble up disconnect
    @socket.on 'disconnect', =>
      @parent = undefined
      this.emit 'disconnect'

    # bubble up message
    @socket.on 'message', (data) =>
      this.emit 'message', data

    @parent = undefined

  sendMessage: (msg) ->
    @socket.emit msg.command, msg.data


  toJSON: ->
    id: @id
    socket: @socket
    parentUrl: @parent.url if @parent?

module.exports = User
