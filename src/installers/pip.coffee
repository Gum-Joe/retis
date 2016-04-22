# File for npm package manager
###
# Module dependencies
###
{spawnSync} = require 'child_process'
require 'colours'
which = require 'which'
{Installer} = require './installer'
###
# Vars
###
pip = module.exports = {}

###
# Pip installer
# @extends InstaLLer
# @param options {Object} Options
# @param loggr {Object} Logger
###
class Pip extends Installer

  constructor: (options, logger) ->
    # body...
    @options = options
    @logger = logger
    @logger.deb('Logger passed to Pip class.')
    @pip_command = which.sync('pip')
  ###
  # Set up args
  ###
  setUpArgs: ->
    # Set up args
    @pip_args.push '--verbose' if typeof @options.debug != 'undefined' && @options.debug && !@options.noVerboseInstall
  ###
  # Install method
  # @param packages {Array} Packages to install
  # @param options {Object} Options
  ###
  install: (packages, options) ->
    @logger.info("Getting pip #{"(python)".blue.bold} global dependencies...")
    if typeof @options.force == 'undefined'
      # body...
      i = 0
      while i < packages.length
        try
          which.sync(i)
        catch error
          if error
            # body...
            @logger.deb("Package #{"\'#{packages[i]}\'".green} already installed. Skipping...")
            delete packages[i]
            # body...
        i++
      # Check
      if packages.length == 1 && packages[0] == "" || packages.length == 0 || typeof packages != 'array'
        # body...
        @logger.info("No pip packages to install.")
        return
    @logger.deb("Fetching packages #{"[".green} #{packages.toString().replace(/,/g, ', ').magenta}  #{"]".green}...")
    @pip_options = options
    @pip_args = packages
    @pip_args.unshift 'install'
    @setUpArgs()
    @logger.deb("Command: #{"\'#{@pip_command}\'".green}")
    @logger.deb("Pip args: #{"[".green} #{@pip_args.toString().replace(/,/g, ', ').magenta}  #{"]".green}...")
    @logger.deb('Running...')
    @logger.running "#{@pip_command.cyan} #{@pip_args.toString().replace(/,/g, ' ').cyan}"
    @exec(@pip_command, @pip_args, (stdout) ->
      # Log stdout
      @logger.stdout stdout
    , (stderr) ->
      @logger.stderr(stderr) if stderr != ""
    )
    return

# Exports
pip.Pip = Pip
