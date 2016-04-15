# File for npm package manager
###
# Module dependencies
###
require 'colours'
###
# Vars
###
npm = module.exports = {}

###
# Class npm
# @param options {Object} Options
# @param loggr {Object} Logger
###
class Npm

  constructor: (options, logger) ->
    # body...
    @options = options
    @logger = logger
    @logger.deb('Logger passed to Npm class.')
    @npm_command = 'npm'
  ###
  # Set up args
  ###
  setUpArgs: ->
    # Set up args
    @npm_args.unshift '--verbose' if typeof @options.debug != 'undefined' && @options.debug
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
    return

# Exports
npm.Npm = Npm
