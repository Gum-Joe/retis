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
# Class npm
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
      if stderr.startsWith('npm verb') || stderr.startsWith('npm info')
        # Verbose logging
        @logger.stdout stderr
      else
        @logger.stderr(stderr) if stderr != " "
    )
    return

# Exports
npm.Npm = Npm
