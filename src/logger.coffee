# Logging module for jakhu

# Module dependencies
debug_module = require 'debug'
require 'colours'

# Vars
app = module.exports = {}
ENV = process.env
that = {};

###
# Logger Class
#
# @class Logger
# @param prefix {String} prefix
###
class Logger

  constructor: (prefix, options) ->
    # body...
    @prefix = prefix
    @debug = debug_module prefix
    @options = options

  ###
  # Info method
  #
  # @colour green
  # @param txt {String} Text to output
  ###
  info: (txt) ->
    # body...
    infostring = "INFO"
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{infostring}".green} #{txt}"
    else
      console.log "#{"[#{@prefix} #{infostring}]".green} #{txt}"

  ###
  # Warn method
  #
  # @colour yellow
  # @param txt {String} Text to output
  ###
  warn: (txt) ->
    # body...
    warnstring = "WARN"
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{warnstring}".yellow} #{txt}"
    else
      console.warn "#{"[#{@prefix} #{warnstring}]".yellow} #{txt}"

  ###
  # Debug method
  #
  # @colour cyan
  # @param txt {String} Text to output
  ###
  deb: (txt) ->
    # body...
    debugstring = "[#{@prefix} DEBUG]".cyan
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{debugstring} #{txt}"
    else if @options.hasOwnProperty('debug') && typeof @options.debug != 'undefined'
      # body...
      console.log "#{debugstring} #{txt}"

# Export
module.exports = Logger: Logger
