# Logging module for jakhu

# Module dependencies
debug_module = require 'debug'
chalk = require 'chalk'
chalk = new chalk.constructor({enabled: true})
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
    infostring = chalk.green("INFO")
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{infostring}".green} #{txt}"
    else
      time = "#{new Date().getHours()}:#{new Date().getMinutes()}:#{new Date().getSeconds()}"
      console.log "#{"[ #{chalk.grey(time)} #{infostring} ]"} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent

  ###
  # Running method
  #
  # @colour magenta
  # @param txt {String} Text to output
  ###
  running: (txt) ->
    # body...
    runningstring = chalk.blue.bold("EXEC")
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{runningstring}".blue.bold} #{txt}"
    else
      time = "#{new Date().getHours()}:#{new Date().getMinutes()}:#{new Date().getSeconds()}"
      console.log "#{"[ #{chalk.grey(time)} #{runningstring} ]"} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent

  ###
  # Stdout method
  #
  # @colour magenta
  # @param txt {String} Text to output
  ###
  stdout: (txt) ->
    # body...
    runningstring = chalk.magenta.bold("SOUT")
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{runningstring}".magenta.bold} #{txt}"
    else
      time = "#{new Date().getHours()}:#{new Date().getMinutes()}:#{new Date().getSeconds()}"
      console.log "#{"[ #{chalk.grey(time)} #{runningstring} ]"} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent

  ###
  # Stderr method
  #
  # @colour red
  # @param txt {String} Text to output
  ###
  stderr: (txt) ->
    # body...
    runningstring = chalk.red.bold("SERR")
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{runningstring}".red.bold} #{txt}"
    else
      time = "#{new Date().getHours()}:#{new Date().getMinutes()}:#{new Date().getSeconds()}"
      console.error "#{"[ #{chalk.grey(time)} #{runningstring} ]"} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent

  ###
  # Error method
  #
  # @colour red
  # @param txt {String} Text to output
  ###
  err: (txt) ->
    # body...
    runningstring = chalk.bgRed("ERROR")
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{runningstring}".red.bold} #{txt}"
    else
      time = "#{new Date().getHours()}:#{new Date().getMinutes()}:#{new Date().getSeconds()}"
      console.error "#{"[ #{chalk.grey(time)} #{runningstring} ]"} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent
  ###
  # Warn method
  #
  # @colour yellow
  # @param txt {String} Text to output
  ###
  warn: (txt) ->
    # body...
    warnstring = chalk.yellow("WARN")
    if typeof ENV['DEBUG'] != 'undefined' && ~ENV['DEBUG'].indexOf @prefix
      # body...
      @debug "#{"#{warnstring}".yellow} #{txt}"
    else
      time = "#{new Date().getHours()}:#{new Date().getMinutes()}:#{new Date().getSeconds()}"
      console.warn "#{"[ #{chalk.grey(time)} #{warnstring} ]"} #{txt}" if not @options.hasOwnProperty('silent') or not @options.silent
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
