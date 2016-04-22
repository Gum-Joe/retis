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
npm = module.exports = {}

###
# Npm installer
# @extends InstaLLer
# @param options {Object} Options
# @param loggr {Object} Logger
###
class Npm extends Installer

  constructor: (options, logger) ->
    # body...
    @options = options
    @logger = logger
    @logger.deb('Logger passed to Npm class.')
    @npm_command = which.sync('npm')
  ###
  # Set up args
  ###
  setUpArgs: ->
    # Set up args
    @npm_args.unshift '--verbose' if typeof @options.debug != 'undefined' && @options.debug && !@options.noVerboseInstall
    @npm_args.push('-g') if @npm_options.hasOwnProperty('global') && @npm_options.global
  ###
  # Install method
  # @param packages {Array} Packages to install
  # @param options {Object} Options
  ###
  install: (packages, options) ->
    @logger.info("Getting npm #{"(nodejs)".green.bold} global dependencies...")
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
        @logger.info("No npm packages to install.")
        return
    @logger.deb("Fetching packages #{"[".green} #{packages.toString().replace(/,/g, ', ').magenta}  #{"]".green}...")
    @npm_options = options
    @npm_args = packages
    @npm_args.unshift 'install'
    @setUpArgs()
    @logger.deb("Command: #{"\'#{@npm_command}\'".green}")
    @logger.deb("NPM args: #{"[".green} #{@npm_args.toString().replace(/,/g, ', ').magenta}  #{"]".green}...")
    @logger.deb('Running...')
    @logger.running "#{@npm_command.cyan} #{@npm_args.toString().replace(/,/g, ' ').cyan}"
    @exec(@npm_command, @npm_args, (stdout) ->
      # Log stdout
      @logger.stdout stdout
    , (stderr) ->
      if stderr.startsWith('npm ERR!') || stderr.startsWith('npm ERR') || stderr.startsWith('npm err!') || stderr.startsWith('npm err')
        @logger.stderr(stderr)
      else
        @logger.stdout(stderr) if stderr != ""
    )
    return

# Exports
npm.Npm = Npm
