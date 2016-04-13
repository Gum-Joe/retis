# Build file for retis

# Module dependencies
{Logger} = require './logger'
fs = require 'fs'
path = require 'path'
{parseConfig} = require './parser'
plugins = require './plugins'
# Vars
app = module.exports = {}

###
# Build method
# @param options {Object} Options
###
app.build = (options) ->
  @logger = new Logger('retis', options)
  @logger.info('Scanning for project specification...')
  @logger.deb("CWD: #{"\'#{process.cwd()}\'".green}")
  @config = parseConfig options
  @name = @config.name if @config.hasOwnProperty 'name'
  @name = process.cwd().split("/") if process.platform != 'win32' && @config.hasOwnProperty('name') == false
  @name = process.cwd().split("\\") if process.platform == 'win32' && @config.hasOwnProperty('name') == false
  @logger.deb("Received config from parser.")
  @logger.deb("Starting build...")
  # Begin build
  @logger.info("");
  @logger.info(":---------------------------------------------:")
  @logger.info("  Building Project \'#{@name[@name.length - 1]}\'...") if @config.hasOwnProperty('name') == false
  @logger.info("  Building Project \'#{@name}\'...") if @config.hasOwnProperty('name') == true
  @logger.info(":---------------------------------------------:")
  @logger.info("");
  # Check for plugins
  if @config.hasOwnProperty 'plugins'
    # body...
    # Download plugins
    @logger.info('Downloading plugins...')
    @logger.info('')
    for p in @config.plugins
      # body...
      plugins.fetchPlugin(p, options)
    @logger.info('Finished downloading plugins.')
  return
