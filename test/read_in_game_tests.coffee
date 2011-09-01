require.paths.unshift([__dirname,'..'].join('/'))

fs = require 'fs'
_  = require 'underscore'

exports['test data format'] = (finish,assert,log) ->

  gameData = fs.readFileSync 'resources/trivia.json'
  gameData = JSON.parse gameData

  assert.equal gameData.length,39
  assert.deepEqual _.keys(gameData[0]), [ 'question', 'answers', 'difficulty' ]
  assert.equal gameData[0].answers.length, 4

  finish()