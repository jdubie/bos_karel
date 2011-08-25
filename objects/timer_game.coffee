require.paths.unshift([__dirname,'..'].join('/'))

Constants = require 'constants'
Game      = require 'objects/game'



class TimerGame extends Game

  pregame = ->
    timeLeft = Constants.JOIN_TIME
    counter = setInterval ->
      timeLeft -= Constants.GAME_SPEED
      if timeLeft == 0
        clearTimeout counter
        self.emit "game:start"

      super.broadcast command: "COUNTER", data: timeLeft
    ,Constants.GAME_SPEED


  @listeners =
    "state:pregame": pregame
    "state:start": ->
      console.error @users

  # override
  handleMessage: (data) ->


module.exports = TimerGame