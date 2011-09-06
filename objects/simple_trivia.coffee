require.paths.unshift([__dirname,'..'].join('/'))

fs = require 'fs'

Game = require 'objects/game'
st   = require 'constants/simple_trivia'

if process.env.NODE_ENV == 'db'
  debug = (msg) ->
    console.error msg
else
  debug = ->



class SimpleTrivia extends Game

  constructor: (master) ->
    gameData = fs.readFileSync 'resources/trivia.json'
    gameData = JSON.parse gameData
    Game.prototype.constructor(gameData,master)

  # over rides super class start
  start: ->

    this.on 'start', =>
      this.state = "GAME"
      debug 'starting game'
      clearInterval @interval

      # if @gameData
      #   counter = 0
      #   @interval = setInterval =>
      #     if counter == @gameData.length - 1
      #       clearInterval @interval
      #     @broadcast command: 'QUESTION', data: @gameData[counter]
      #     counter++
      #   ,st.TIME_GAME_QUESTION


    this.state = "PRE_GAME"
    debug 'starting pre-game'

    this.timeout = setTimeout =>
      this.emit 'start'
    ,st.TIME_PRE_GAME_TIMEOUT

    this.timeRemaining = st.TIME_PRE_GAME_TIMEOUT
    this.interval = setInterval =>
      @timeRemaining -= st.TIME_PRE_GAME_INTERVAL
      @master.sendMessage command: 'TIME', data: @timeRemaining
    ,st.TIME_PRE_GAME_INTERVAL

  addUser: (user) ->
    if this.state == "PRE_GAME"
      # Game.prototype.addUser(user)
      Game.prototype.addUser.call(this,user)

module.exports = SimpleTrivia