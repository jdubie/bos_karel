CONFIG_DIR = "#{__dirname}/config"

fs      = require('fs')

# load server credentials.
pwds    = fs.readFileSync [CONFIG_DIR,"pwd.json"].join("/")
pwds    = JSON.parse(pwds)

envInfo = fs.readFileSync [CONFIG_DIR,"env.json"].join("/")
envInfo = JSON.parse(envInfo)

if process.env.MTAUR_DEBUG && /env/.test(process.env.MTAUR_DEBUG)
  debug = (x) -> console.error('ENV:', x)
else
  debug = ->


module.exports.Port = pwds["client-#{envInfo.cluster_env}"].port
module.exports.host = pwds["client-#{envInfo.cluster_env}"].host