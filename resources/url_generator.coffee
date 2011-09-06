actors = [
  'tom-cruise'
  'will-smith'
  'mandy-moore'
  'mike-myers'
]

module.exports.getUrl = ->
  actors[Math.floor(Math.random()*actors.length)]