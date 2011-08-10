require.paths.unshift([__dirname,'..'].join('/'))

user   = require 'objects/user'
events = require 'events'

class FakeSocket extends events.EventEmitter
  constructor: (@id) ->

exports['test creating a user'] = (finish,assert) ->

  fakeSocket = new FakeSocket('id123')
  testUser = new user(fakeSocket)

  assert.deepEqual testUser.socket, fakeSocket
  assert.ok testUser.id = fakeSocket.id

  finish()


exports['test sending message to user'] = (finish,assert) ->

  command = 'answer'
  data = this: 'is data'

  fakeSocket = new FakeSocket('id123')
  fakeSocket.on command, (d) ->
    assert.deepEqual d, data
    finish()

  testUser = new user(fakeSocket)
  testUser.sendMessage command: 'answer', data: data

exports['test socket disconnect'] = (finish,assert,log) ->

  fakeSocket = new FakeSocket('id123')
  testUser = new user(fakeSocket)
  testUser.parent = 'austin powers faiser'

  testUser.on 'disconnect', ->
    assert.ok testUser.parent == undefined
    finish()

  fakeSocket.emit 'disconnect'

