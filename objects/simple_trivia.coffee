fs = require 'fs'

Game = require './game'

if process.env.NODE_ENV == 'db'
  debug = (msg) ->
    console.error msg
else
  debug = ->


PRE_GAME = 1000*5

class SimpleTrivia extends Game

  constructor: (master) ->
    gameData = fs.readFileSync 'resources/trivia.json'
    gameData = JSON.parse gameData
    Game.prototype.constructor.call(this,gameData,master)

  # over rides super class start
  start: ->

    this.on 'start', =>
      this.state = "GAME"
      debug 'starting game'
      clearInterval this.interval

      if @gameData
        counter = 0
        this.interval = setInterval =>
          if counter == @gameData.length - 1
            clearInterval this.interval
          this.broadcast command: 'QUESTION', data: @gameData[counter]
          counter++
        ,1000


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