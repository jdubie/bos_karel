require.paths.unshift([__dirname,'..'].join('/'))

events = require 'events'
_      = require 'underscore'
combo  = require 'combo'
Game   = require 'objects/game'
User   = require 'objects/user'


class FakeSocket extends events.EventEmitter
  constructor: (@id) ->

exports['test creating game'] = (finish,assert,log) ->

  # log new game
  testGame = new Game game: 'data' # empty game data

  # test properly creates instance variables
  assert.ok testGame.users
  assert.ok testGame.gameData
  assert.ok testGame.url

  assert.deepEqual testGame.gameData, game: 'data'

  finish()


exports['test adding a user'] = (finish,assert,log) ->

  socketId = 'abc123'

  fakeSocket = new FakeSocket(socketId)
  testUser = new User(fakeSocket)

  testGame = new Game

  testGame.addUser testUser

  assert.deepEqual testGame.users[socketId], testUser
  assert.equal (_.keys testGame.users).length, 1

  finish()


exports['test adding and disconnecting n users'] = (finish,assert,log) ->

  n = 3
  socketIds = ("abc#{i}" for i in [0...n])
  users = _.map socketIds, (id) -> new User(new FakeSocket(id))

  game = new Game

  _.map users, (user) -> game.addUser user

  assert.equal (_.keys game.users).length, socketIds.length
  for id,user of game.users
    assert.ok id in socketIds
    assert.ok user in users
    assert.deepEqual user.parent, game

  _.map users, (user) -> user.emit 'disconnect'

  assert.equal game.numUsers(), 0

  finish()

exports['test broadcast'] = (finish,assert) ->

  n = 100
  socketIds = ("abc#{i}" for i in [0...n])
  users = _.map socketIds, (id) -> new User(new FakeSocket(id))
  game = new Game
  _.map users, (user) -> game.addUser user

  cbs = new combo.Combo (messages) ->
    finish()

  for user in users
    user.socket.on 'yo', cbs.add()

  game.broadcast command: 'yo', message: 'whats up broskis?'

# exports['test message where'] = (finish,assert,log) ->

#   wrongUser = new User(new FakeSocket('wrong'))
#   rightUser = new User(new FakeSocket('right'))
#   game = new Game
#   game.addUser wrongUser
#   game.addUser rightUser

#   wrongUser.socket.on 'resp', (message) ->
#     assert.fail "this user should not be recieving this message"
#     finish()

#   rightUser.socket.on 'resp', (message) ->
#     assert.equal message, "right"
#     setTimeout finish, 10

#   game.messageWhere command: 'resp', data: 'right', (id,users) ->
#     users[id].id == 'right'