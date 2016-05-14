# Logging module for jakhu

# Module dependencies
debug_module = require 'debug'
require 'colours'

# Vars
ENV = process.env

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
    @starttime = Date.now()

    # RM console.log for silent build
    if typeof @options.silent != 'undefined' and @options.silent
      console.log = () ->
        return

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
      console.log "#{"[#{@prefix} #{infostring}]".green} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent

  ###
  # Running method
  #
  # @colour magenta
  # @param txt {String} Text to output
  ###
  running: (txt) ->
    # body...
    runningstring = "EXEC"
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{runningstring}".blue.bold} #{txt}"
    else
      console.log "#{"[#{@prefix} #{runningstring}]".blue.bold} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent

  ###
  # Stdout method
  #
  # @colour magenta
  # @param txt {String} Text to output
  ###
  stdout: (txt) ->
    # body...
    runningstring = "SOUT"
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{runningstring}".magenta.bold} #{txt}"
    else
      console.log "#{"[#{@prefix} #{runningstring}]".magenta.bold} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent

  ###
  # Stderr method
  #
  # @colour red
  # @param txt {String} Text to output
  ###
  stderr: (txt) ->
    # body...
    runningstring = "SERR"
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{runningstring}".red.bold} #{txt}"
    else
      console.error "#{"[#{@prefix} #{runningstring}]".red.bold} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent

  ###
  # Error method
  #
  # @colour red
  # @param txt {String} Text to output
  ###
  err: (txt) ->
    # body...
    runningstring = "ERROR!"
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{runningstring}".red.bold} #{txt}"
    else
      console.error "#{"[#{@prefix} #{runningstring}]".red.bold} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent

  ###
  # Warn method
  #
  # @colour yellow
  # @param txt {String} Text to output
  ###
  warn: (txt) ->
    # body...
    warnstring = "WARN!"
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{warnstring}".yellow} #{txt}"
    else
      console.warn "#{"[#{@prefix} #{warnstring}]".yellow} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent

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
      @debug "#{debugstring.cyan} #{txt}"
    else if @options.hasOwnProperty('debug') && typeof @options.debug != 'undefined'
      # body...
      console.log "#{"[#{@prefix} #{debugstring}]".cyan} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent

# Export
module.exports = Logger: Logger
