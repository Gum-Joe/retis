# Logging module for jakhu

# Module dependencies
debug_module = require 'debug'
require 'colours'

# Vars
app = module.exports = {}
ENV = process.env

###
# Logger Class
#
# @class Logger
# @param prefix {String} prefix
###
class Logger

  constructor: (prefix) ->
    # body...
    @prefix = prefix
    @debug = debug_module prefix

  ###
  # Info method
  #
  # @colour green
  # @param txt {String} Text to output
  ###
  info: (txt) ->
    # body...
    if ENV.DEBUG.indexOf @prefix
      # body...
      @debug txt
    else
      console.log txt
