Game = require './game'

if process.env.NODE_ENV == 'db'
  debug = (msg) ->
    console.error msg
else
  debug = ->


PRE_GAME = 1000*5


class SimpleTrivia extends Game

  # over rides super class start
  start: ->

    this.on 'start', =>
      this.state = "GAME"
      debug 'starting game'
      clearInterval this.interval

    this.state = "PRE_GAME"
    debug 'starting pre-game'

    this.timeout = setTimeout =>
      this.emit 'start'
    ,PRE_GAME

    this.timeRemaining = PRE_GAME
    this.interval = setInterval =>
      this.timeRemaining -= 1000
      this.broadcast command: 'TIME', data: this.timeRemaining
    ,1000

  addUser: (user) ->
    if this.state == "PRE_GAME"
      Game.prototype.addUser.call(this,user)

module.exports = SimpleTrivia