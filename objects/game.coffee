events       = require 'events'
urlGenerator = require '../resources/url_generator'
_            = require 'underscore'

class Game extends events.EventEmitter

  constructor: (@gameData,@master) ->
    @url = urlGenerator.getUrl()
    @users = {}
    # console.error @master?
    # console.error this.addUser.toString()
    this.addUser(@master) if @master?
    # console.error @users

  addUser: (user) ->
    # console.error 'here'
    # console.error user

    # assign this user's parent
    user.parent = this

    # delete user on disconnect
    user.on 'disconnect', =>
      delete @users[user.id]
      user = undefined

    user.on 'message', (data) =>
      handleMessage data

    # add user
    @users[user.id] = user

  numUsers: ->
    (_.keys @users).length

  # private
  broadcast: (data) ->
    this.multicast data, (_.keys @users)
    # _.each (_.values @users), (user) -> user.sendMessage data

  multicast: (data,ids) ->
    _.each ids, (id) => @users[id].sendMessage data

  messageWhere: (data,criteria) ->
    this.multicast data, (_.select (_.keys @users), (id) => criteria(id,@users))


  handleMessage: (data) ->
    # to be overwritten by subclass


module.exports = Game