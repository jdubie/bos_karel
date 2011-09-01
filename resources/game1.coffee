csv = require 'ya-csv'

questions = []

module.exports = (callback) ->
  reader = csv.createCsvFileReader('./trivia.csv')
  reader.on 'data', (data) ->

    question = {}

    question.question   = data[0]
    question.answers    = (data[i] for i in [1..4])
    question.difficulty = data[5]

    questions.push question

  reader.on 'end', ->
    callback questions

  # console.error data[0]


# fs = require 'fs'

# file = fs.readFileSync 'resources/trivia.csv', 'utf8'

# questions = []

# lines = file.split '\n'
# for line in lines

#   question = {}

#   fields = line.split ','

#   question.question   = fields[0]
#   question.answers    = [fields[1],fields[2],fields[3],fields[4]]
#   question.difficulty = fields[5]

#   questions.push question unless fields[0] == ''

# module.exports = questions
