require.paths.unshift([__dirname,'..'].join('/'))

events       = require 'events'
_            = require 'underscore'
User         = require 'objects/user'
SimpleTrivia = require 'objects/simple_trivia'

exports['test state of game changes on events'] = (finish,assert,log) ->

  st = new SimpleTrivia
  st.start()
  clearTimeout st.timeout

  assert.equal st.state, 'PRE_GAME'

  st.emit 'start'

  assert.equal st.state, 'GAME'

  finish()

class FakeSocket extends events.EventEmitter
  constructor: (@id) ->

exports['test no users can join during game'] = (finish,assert,log) ->

  st = new SimpleTrivia
  fs = new FakeSocket
  st.start()
  clearTimeout st.timeout

  st.emit 'start' # now game is no longer in PRE_GAME

  user = new User fs
  st.addUser user

  assert.deepEqual st.users, {}

  finish()

exports['test we can add users during pregame'] = (finish,assert,log) ->

  id = 'wefwefwef'

  st = new SimpleTrivia
  fs = new FakeSocket id
  st.start()
  clearTimeout st.timeout

  # still in PRE_GAME so should be able to add users
  user = new User fs
  st.addUser user

  # log st.users
  assert.equal st.users[id].id, id
  assert.equal (_.keys st.users).length, 1

  finish()

exports['test we get broadcast of time remaining'] = (finish,assert,log) ->

  id = 'wefwefwef'

  st = new SimpleTrivia
  fs = new FakeSocket id

  first = undefined
  fs.on 'TIME', (data) ->
    if first?
      assert.ok Math.abs(first - 1000 - data) < 10
      # clearTimeout st.timeout
      # clearInterval st.interval
      finish()
    first = data

  st.start()

  user = new User fs
  st.addUser user
