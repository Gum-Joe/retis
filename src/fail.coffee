# Fail build
###
# Module dependencies
###
require 'colours'
callerId = require 'caller-id'
path = require 'path'
util = require 'util'
upath = require 'upath'
###
# Vars
###
tab = " "
###
# Fail build
# @param err {Error} Error to fail with
###
module.exports = (err) ->
  # Format taken from Apache Maven
  memory = process.memoryUsage()
  mems = "#{Math.round(memory.heapUsed / 1024 / 1024)} / #{Math.round(memory.heapTotal / 1024 / 1024)} MB "
  filePath = upath.normalize(callerId.getData().filePath)
  error_array = err.stack.split('\n')
  filePath2 = upath.normalize(error_array[1])
  @logger.err('-----------------------------------------------------------------')
  @logger.err("#{tab}BUILD FAILURE!")
  @logger.err('-----------------------------------------------------------------')
  @logger.err("#{tab}Finished at: #{Date()}")
  @logger.err("#{tab}Memory: #{mems}")
  @logger.err("#{tab}Build duration: #{(Date.now() - @logger.starttime) / 100} s")
  @logger.err('-----------------------------------------------------------------')
  @logger.err("")
  # Show err info
  @logger.err("#{error_array[0]}")
  @logger.err("")
  if filePath2.includes('node_modules/retis') or filePath2.includes('node_modules/retis-ci') or (filePath2.includes('retis-ci') and process.env.NODE_ENV != 'production') or (filePath2.includes('retisci') and process.env.NODE_ENV != 'production')
    if !(filePath2.includes('node_modules/retis/node_modules') or filePath2.includes('node_modules/retis-ci/node_modules') or (filePath2.includes('retis-ci/node_modules') and process.env.NODE_ENV != 'production') or (filePath2.includes('retisci/node_modules') and process.env.NODE_ENV != 'production'))
      @logger.err("This is a problem with retis. Please file an issue at https://github.com/jakhu/retis-ci.")
      # From node-gyp
      @logger.err("#{tab}<https://github.com/jakhu/retis-ci>")
      @logger.err("")
    else
      @logger.err("This is a problem with one of retis's dependencies. Please file an issue at https://github.com/jakhu/retis-ci.")
      # From node-gyp
      @logger.err("#{tab}<https://github.com/jakhu/retis-ci>")
      @logger.err("")
  else
    @logger.err("This is not a problem with retis, but a problem with a 3rd party package or tool.")
  if @options.hasOwnProperty('debug') && @options.debug
    @logger.err("#{tab}File: #{filePath},")
    @logger.err("#{tab}Function: #{callerId.getData().functionName}()")
  @logger.err("")
  # options.onError: ran on error
  if @options.hasOwnProperty('onError')
    @options.onError(err)
  else
    if (@options.hasOwnProperty('trace') && @options.trace) or (@options.hasOwnProperty('debug') && @options.debug) or (process.env.NODE_ENV == 'dev' or process.env.NODE_ENV == 'development')
      @logger.err("Full error message:")
      @logger.err("")
      for e in error_array
        @logger.err(e)
    else
      @logger.err("Re-run retis with the -e switch to show full error message and stack trace.")
      @logger.err("Re-run with the --debug switch for debug logging")
      @logger.err("Re-run with the -s switch to show command output")
    @logger.err("1 Error(s)")
    process.exit(1)
