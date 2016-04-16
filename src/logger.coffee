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
  # Running method
  #
  # @colour magenta
  # @param txt {String} Text to output
  ###
  running: (txt) ->
    # body...
    runningstring = "RUN"
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{runningstring}".magenta} #{txt}"
    else
      console.log "#{"[#{@prefix} #{runningstring}]".magenta} #{txt}"

  ###
  # Stdout method
  #
  # @colour magenta
  # @param txt {String} Text to output
  ###
  stdout: (txt) ->
    # body...
    runningstring = "STDOUT"
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{runningstring}".magenta} #{txt}"
    else
      console.log "#{"[#{@prefix} #{runningstring}]".magenta} #{txt}"

  ###
  # Stderr method
  #
  # @colour magenta
  # @param txt {String} Text to output
  ###
  stderr: (txt) ->
    # body...
    runningstring = "STDERR"
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{runningstring}".red} #{txt}"
    else
      console.log "#{"[#{@prefix} #{runningstring}]".red} #{txt}"

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
    debugstring = "DEBUG"
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{debugstring} #{txt}"
    else if @options.hasOwnProperty('debug') && typeof @options.debug != 'undefined'
      # body...
      console.log "#{"[#{@prefix} #{debugstring}]".cyan} #{txt}"

# Export
module.exports = Logger: Logger
