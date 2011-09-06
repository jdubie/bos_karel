require.paths.unshift([__dirname,'node_modules'].join('/'))

fs      = require('fs')
spawn   = require('child_process').spawn
exec    = require('child_process').exec
_       = require('underscore')
events  = require('events')

# testing

option '-O', '--only [TEST]', 'for testing, only run one file.'
option '-E', '--except [TEST]', 'for testing, only run one file.'
option '-S', '--silent', 'make exit(0) entirely quiet.'
option '-V', '--verbose', 'make tests run loud.'
option '-T', '--timeout [NUM]', 'timeout for tests'

task 'test', 'runs all tests suites found in test/. optionall takes --except [TEST] and --only [TEST] for focus.', (options) ->

  process.env.NODE_ENV = "test"

  exec 'find test -name "*.coffee" -print', (err, stdout, stderr) ->
    testFiles = stdout.split("\n")
    testFiles = _.select(testFiles, (file) -> file.match(/_test/))
    testFiles = _.reject(testFiles, (file) -> !file.match(options.only)) if options.only?
    testFiles = _.reject(testFiles, (file) -> file.match(options.except)) if options.except?
    testFiles = _.reject(testFiles, (file) -> file.match(/init.js/))
    testFiles = _.compact(testFiles)
    console.log("testing:", testFiles) unless options.silent?

    runner = require './test_runner'
    runner.run testFiles, options.verbose?



