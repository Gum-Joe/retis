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
gem = module.exports = {}

###
# Class npm
# @param options {Object} Options
# @param loggr {Object} Logger
###
class Gem extends Installer

  constructor: (options, logger) ->
    # body...
    @options = options
    @logger = logger
    @logger.deb('Logger passed to Gem class.')
    @gem_command = which.sync('gem')
  ###
  # Set up args
  ###
  setUpArgs: ->
    # Set up args
    @gem_args.push '--verbose' if typeof @options.debug != 'undefined' && @options.debug && !@options.noVerboseInstall
  ###
  # Install method
  # @param packages {Array} Packages to install
  # @param options {Object} Options
  ###
  install: (packages, options) ->
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
        @logger.deb("No gem packages to install.")
        return
    @logger.deb("Fetching packages #{"[".green} #{packages.toString().replace(/,/g, ', ').magenta}  #{"]".green}...")
    @gem_options = options
    @gem_args = packages
    @gem_args.unshift 'install'
    @setUpArgs()
    @logger.deb("Command: #{"\'#{@gem_command}\'".green}")
    @logger.deb("Gem args: #{"[".green} #{@gem_args.toString().replace(/,/g, ', ').magenta}  #{"]".green}...")
    @logger.deb('Running...')
    @logger.running "#{@gem_command.cyan} #{@gem_args.toString().replace(/,/g, ' ').cyan}"
    @exec(@gem_command, @gem_args, (stdout) ->
      # Log stdout
      @logger.stdout stdout
    , (stderr) ->
      @logger.stderr(stderr) if stderr != ""
    )
    return

# Exports
gem.Gem = Gem
