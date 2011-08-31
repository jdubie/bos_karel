fs = require 'fs'

file = fs.readFileSync 'resources/trivia.csv', 'utf8'

questions = []

lines = file.split '\n'
for line in lines

  question = {}

  fields = line.split ','

  question.question   = fields[0]
  question.answers    = [fields[1],fields[2],fields[3],fields[4]]
  question.difficulty = fields[5]

  questions.push question unless fields[0] == ''

module.exports = questions
