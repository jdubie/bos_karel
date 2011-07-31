io     = require('socket.io')
static = require('node-static')
http   = require('http')
_      = require('underscore')

fs = require('fs')
contestant = fs.readFileSync('client/contestant/index.html')
master = fs.readFileSync('client/master/index.html')
master_style = fs.readFileSync('client/master/style.css')
qrcode = fs.readFileSync('client/master/qrcode.js')
qrcanvas = fs.readFileSync('client/master/qrcanvas.js')

app = require('express').createServer();

## load files for master
app.get '/', (req, res) ->
  res.writeHead 200, {'Content-Type': 'text/html'}
  res.end master
app.get "/style.css", (req,res) ->
  res.writeHead 200, {'Content-Type': 'text/css'}
  res.end master_style
app.get "/qrcode.js", (req,res) ->
  res.writeHead 200, {'Content-Type': 'text/javascript'}
  res.end qrcode
app.get "/qrcanvas.js", (req,res) ->
  res.writeHead 200, {'Content-Type': 'text/javascript'}
  res.end qrcanvas


## load files for contestant
app.get "/:id", (req,res) ->
  res.writeHead 200, {'Content-Type': 'text/html'}
  res.end contestant


# list of sockets
curGame = []


## read in game
game = require('./content/game1.coffee')

## constants
TIME = 6000
end = game.length*TIME

## per round
index = 0
correctIndex = -1
contenters = []
advancers = {}

gameStarted = false

broadcast = (array) ->
  # beginning buffer
  setTimeout ->

    intervalId = setInterval ->

      gameStarted = true

      contents = _.select _.keys(advancers), (candidate) ->
        advancers[candidate]
      advancers = {}

      if ++index == game.length - 1
        clearInterval intervalId

      correct = game[index].answers[0]
      questions = game[index].answers
      questions.sort -> 0.5 - Math.random()
      correctIndex = questions.indexOf(correct) + 1

      for player in array
        player.emit 'data', question: game[index].question, q1: questions[0], q2: questions[1], q3: questions[2], q4: questions[3]

    ,TIME

  ,4000





# socket server to listen to socket connections
io = io.listen(app)
app.listen(3000)

io.sockets.on 'connection', (socket) ->
  socket
    .on 'master', ->
      socket.emit 'link', 0
      console.log 'master connection'

      curGame.push socket
      broadcast curGame

    .on 'contestant', (info) ->
      console.error 'contestant'
      curGame.push socket
      contenters.push socket.id unless gameStarted

    .on 'answer', (answer) ->

      # if they're still in the game and haven't answered yet
      if contenters.indexOf(socket.id) != -1 and !advancers[socket.id]?
        advancers[socket.id] = answer == correctIndex
        socket.emit "answer", answer == correctIndex

