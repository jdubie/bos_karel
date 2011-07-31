events       = require 'events'
urlGenerator = require './resources/url_generator'
_            = require 'underscore'

class Game extends events.EventEmitter

  constructor: (@gameData) ->
    @users = {}
    @url = urlGenerator.getUrl()

  addUser: (user) ->

    # delete user on disconnect
    user.on 'disconnect', ->
      delete @users[user.id]

    # add user
    @users[user.id] = user


  # private
  broadcast: (data) ->
    _.each (_.values @users), (user) -> user.sendMessage data
