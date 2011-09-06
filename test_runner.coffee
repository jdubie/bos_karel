combo    = require 'combo'
_        = require 'underscore'
terminal = require 'terminal'


printError = (error) ->
  JSON.stringify(error)

setupFun = (testName,test,callback) ->

  ->
    assert = require 'assert'

    cb = ->
      # test = undefined ## for garabage collection?
      terminal.puts "#{testName}\t\t\t[green]PASSED[/green]"
      callback(testName,"Pass")

    log = (msg) ->
      terminal.puts "[#{testName}] [blue]#{JSON.stringify(msg)}[/blue]"

    try
      test cb, assert, log
    catch err
      terminal.puts "#{testName}\t\t\t[red]FAILED[/red]"
      callback(testName,"Fail")
      throw err

module.exports.run = (testFiles,verbose) ->

  tests = {}
  for testFile in testFiles
    testsInFile = require "./#{testFile}"
    descriptiveTests = {}
    for testName, test of testsInFile
      descriptiveTests["#{testFile}: #{testName}"] = test
    _.extend tests, descriptiveTests

  # set callback
  cbs = new combo.Combo (callbacks...) ->
    terminal.puts '\n[green]ALL TESTS COMPLETE[/green]\n'
    process.exit(0) unless verbose

  # create closure
  tests = _.map (_.keys tests), (test) ->
    setupFun test,tests[test],cbs.add()

  # run tests
  for test in tests
    test()