require.paths.unshift([__dirname,'..'].join('/'))

events       = require 'events'
_            = require 'underscore'
User         = require 'objects/user'
Game         = require 'objects/game'
SimpleTrivia = require 'objects/simple_trivia'

st = require 'constants/simple_trivia'


class FakeSocket extends events.EventEmitter
  constructor: (@id) ->

exports['test state of game changes on events'] = (finish,assert,log) ->

  masterSocket = new FakeSocket 'master'
  simpleTrivial = new SimpleTrivia new User masterSocket
  simpleTrivial.start()
  clearTimeout simpleTrivial.timeout

  assert.equal simpleTrivial.state, 'PRE_GAME'

  simpleTrivial.emit 'start'

  assert.equal simpleTrivial.state, 'GAME'

  finish()

exports['test no users can join during game'] = (finish,assert,log) ->

  masterSocket = new FakeSocket 'master'
  simpleTrivial = new SimpleTrivia new User masterSocket
  fs = new FakeSocket 'cantJoin'
  simpleTrivial.start()
  clearTimeout simpleTrivial.timeout

  simpleTrivial.emit 'start' # now game is no longer in PRE_GAME

  user = new User fs
  simpleTrivial.addUser user

  # should only be master and not cantJoin
  assert.equal _.keys(simpleTrivial.users).length, 1
  assert.equal simpleTrivial.users['cantJoin'], undefined
  assert.equal simpleTrivial.users['master'].id, 'master'

  finish()

exports['test we can add users during pregame'] = (finish,assert,log) ->

  id = 'wefwefwef'

  masterSocket = new FakeSocket 'master'
  simpleTrivial = new SimpleTrivia new User masterSocket
  fs = new FakeSocket id
  simpleTrivial.start()
  clearTimeout simpleTrivial.timeout

  # still in PRE_GAME so should be able to add users
  user = new User fs
  simpleTrivial.addUser user

  # log st.users
  assert.equal simpleTrivial.users[id].id, id
  assert.equal (_.keys simpleTrivial.users).length, 1+1 # 1 for master

  finish()


# exports['test we get broadcast of time remaining'] = (finish,assert,log) ->

#   id = 'wefwefwef'

#   masterSocket = new FakeSocket 'master'
#   simpleTrivial = new SimpleTrivia new User masterSocket

#   first = undefined
#   masterSocket.on 'TIME', (data) ->
#     if first?
#       assert.ok Math.abs(first - 1000 - data) < 10
#       finish()
#     first = data

#   simpleTrivial.start()


exports['test we can create a trivia game with data'] = (finish,assert,log) ->

  fs = new FakeSocket 'idwef'
  st = new SimpleTrivia new User fs
  assert.ok st.gameData
  finish()

exports['test we can create a trivia game with master'] = (finish,assert,log) ->

  fs = new FakeSocket 'idwef'
  st = new SimpleTrivia new User fs

  assert.ok st.master
  assert.equal st.master.id, 'idwef'
  finish()

exports['test that master is also a user'] = (finish,assert,log) ->

  fs = new FakeSocket 'idwef'
  st = new SimpleTrivia(new User(fs))

  assert.equal _.keys(st.users).length, 1
  assert.equal st.users['idwef'].id, 'idwef'

  finish()

# # exports['test we questions broadcasted'] = (finish,assert,log) ->

# #   id = 'few'

# #   fs = new FakeSocket id
# #   masterSocket = new FakeSocket 'master'
# #   st = new SimpleTrivia new User masterSocket

# #   i = 0
# #   fs.on 'QUESTION', (data) ->
# #     assert.equal st.gameData[i], data
# #     i++
# #     if i == 2 #gameData.length
# #       finish()

# #   st.start()
# #   clearTimeout st.timeout
# #   clearInterval st.interval

# #   user = new User fs
# #   st.addUser user

# #   st.emit 'start'
