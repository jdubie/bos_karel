require.paths.unshift([__dirname,'.'].join('/'))

express      = require 'express'
io           = require 'socket.io'
_            = require 'underscore'

env          = require 'env'
resources    = require 'resources/game1'
trivia       = require 'objects/simple_trivia'

User         = require 'objects/user'


if process.env.DEBUG
  debug = (x) -> console.error('SERVER: ', x)
else
  debug = ->


app = express.createServer()

# Setup Template Engine
app.register '.coffee', require 'coffeekup'
app.set 'view engine', 'coffee'

# Setup Static Files
app.use express.static __dirname + '/public'

# App Routes
app.get '/', (req, resp) ->
  resp.render 'index', layout: false

app.get '/env.js', (res,resp) ->
  environment = """
    window.trivia_host = \"#{env.Host}\";
    window.trivia_port = #{env.Port};
  """
  resp.end environment

app.get '/:id', (req, resp) ->
  resp.render 'contestant/index',
    layout: false


games = {}

# socket server to listen to socket connections
io = io.listen(app)
app.listen env.Port


io.sockets.on 'connection', (socket) ->

  socket

    .on 'master', ->

      game = new trivia resources, socket
      games[game.url] = game
      game.start()

      # add master as user
      game.addUser new User socket

    .on 'contestant', (url) ->

      games[url].addUser new User socket



# io.sockets.on 'connection', (socket) ->
#   socket
#     .on 'master', ->
#       socket.emit 'link', 0
#       console.log 'master connection'

#       curGame.push socket
#       broadcast curGame

#     .on 'contestant', (info) ->
#       console.error 'contestant'
#       curGame.push socket
#       contenters.push socket.id unless gameStarted

#     .on 'answer', (answer) ->

#       # if they're still in the game and haven't answered yet
#       if contenters.indexOf(socket.id) != -1 and !advancers[socket.id]?
#         advancers[socket.id] = answer == correctIndex
#         socket.emit "answer", answer == correctIndex





# # list of sockets
# curGame = []


# ## read in game
# game = require('./content/game1.coffee')

# ## constants
# TIME = 6000
# end = game.length*TIME

# ## per round
# index = 0
# correctIndex = -1
# contenters = []
# advancers = {}

# gameStarted = false

# broadcast = (array) ->
#   # beginning buffer
#   setTimeout ->

#     intervalId = setInterval ->

#       gameStarted = true

#       contents = _.select _.keys(advancers), (candidate) ->
#         advancers[candidate]
#       advancers = {}

#       if ++index == game.length - 1
#         clearInterval intervalId

#       correct = game[index].answers[0]
#       questions = game[index].answers
#       questions.sort -> 0.5 - Math.random()
#       correctIndex = questions.indexOf(correct) + 1

#       for player in array
#         player.emit 'data', question: game[index].question, q1: questions[0], q2: questions[1], q3: questions[2], q4: questions[3]

#     ,TIME

#   ,4000
