require.paths.unshift([__dirname,'.'].join('/'))

fs           = require 'fs'
express      = require 'express'
_            = require 'underscore'

# code = fs.readFileSync 'code.json'
# code = JSON.parse code

app = express.createServer()

# Setup Template Engine
app.register '.jade', require 'jade'
app.set 'view engine', 'jade'

# Setup Static Files
app.use express.static __dirname + '/public'

# App Routes
app.get '/', (req, resp) ->
  resp.render 'index',
    layout: false
    code: '//write your karel javascript\n//code here.\n\nfunction run() {\n\n}'

app.get '/:user/:map', (req, resp) ->

  code = fs.readFileSync 'code.json'
  code = JSON.parse code

  resp.render 'index',
    layout : false
    map    : req.params.map
    code   : code[req.params.user][req.params.map]

app.listen 3000

