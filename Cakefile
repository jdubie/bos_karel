require.paths.unshift([__dirname,'node_modules'].join('/'))

fs      = require('fs')
spawn   = require('child_process').spawn
exec    = require('child_process').exec
_       = require('underscore')
events  = require('events')

TEST_TIMEOUT = "10000"

# testing

option '-O', '--only [TEST]', 'for testing, only run one file.'
option '-E', '--except [TEST]', 'for testing, only run one file.'
option '-S', '--silent', 'make exit(0) entirely quiet.'
option '-V', '--verbose', 'make tests run loud.'
option '-T', '--timeout [NUM]', 'timeout for tests'

task 'test', 'runs all tests suites found in test/. optionall takes --except [TEST] and --only [TEST] for focus.', (options) ->

  process.env.NODE_ENV = "test"

  # testEnv = spawn 'coffee', ['./test/env.coffee'], env: process.env
  # if options.verbose
  #   testEnv.stdout.on 'data', (data) -> process.stdout.write data.toString()
  #   testEnv.stderr.on 'data', (data) -> process.stdout.write data.toString()

  # testEnv.stderr.on 'data', (data) ->
    # if data.toString() == "RDY" # emitted from the test environment to signal initialized.

  exec 'find test -name "*.coffee" -print', (err, stdout, stderr) ->
    testFiles = stdout.split("\n")
    testFiles = _.select(testFiles, (file) -> file.match(/_test/))
    testFiles = _.reject(testFiles, (file) -> !file.match(options.only)) if options.only?
    testFiles = _.reject(testFiles, (file) -> file.match(options.except)) if options.except?
    testFiles = _.reject(testFiles, (file) -> file.match(/init.js/))
    testFiles = _.compact(testFiles)
    console.log("testing:", testFiles) unless options.silent?

    # testOpts  = "--tests \"#{testFiles.join(" ")}\""

    TEST_TIMEOUT = options.timeout if options.timeout?

    # console.log("exec:", "NODE_ENV=test ./node_modules/whiskey/bin/whiskey #{testOpts}") unless options.silent?
    # test = spawn "./node_modules/whiskey/bin/whiskey", _.flatten(["--concurrency","1","--timeout",TEST_TIMEOUT,"--print-stderr","--tests", testFiles.join(" ")]), env: process.env
    # test = spawn "coffee", "test_runner.coffee"#, "args", env: process.env

    # test.stdout.on 'data', (data) -> process.stdout.write(data.toString())
    # test.stderr.on 'data', (data) -> process.stdout.write(data.toString())

    # test.on 'exit', (code) ->
    # #   # testEnv.kill('SIGTERM')
    #   process.exit(code)

    runner = require './test_runner'

    runner.run testFiles, options.verbose?



