# Build file for retis

# Module dependencies
{Logger} = require './logger'
fs = require 'fs'
path = require 'path'
{parseConfig} = require './parser'
plugins = require './plugins'
waituntil = require 'wait-until'
os = require 'os'
{execBuild} = require './builder/executer'
# Vars
app = module.exports = {}
retis_plugin_dir = '.retis/plugins'
retis_plugin_dir = path.join(os.homedir(), retis_plugin_dir)

###
# Build method
# @param options {Object} Options
###
app.build = (options) ->
  _logger = new Logger('retis', options)
  _logger.info('Scanning for project specification...')
  _logger.deb("CWD: #{"\'#{process.cwd()}\'".green}")
  config = parseConfig options
  @name = config.name if config.hasOwnProperty 'name'
  @name = process.cwd().split("/") if process.platform != 'win32' && config.hasOwnProperty('name') == false
  @name = process.cwd().split("\\") if process.platform == 'win32' && config.hasOwnProperty('name') == false
  _logger.deb("Received config from parser.")
  _logger.deb("Starting build...")
  # Begin build
  _logger.info("");
  _logger.info(":---------------------------------------------:")
  _logger.info("  Building Project \'#{@name[@name.length - 1]}\'...") if config.hasOwnProperty('name') == false
  _logger.info("  Building Project \'#{@name}\'...") if config.hasOwnProperty('name') == true
  _logger.info(":---------------------------------------------:")
  _logger.info("");
  # Check for plugins
  if config.hasOwnProperty 'plugins'
    # body...
    # Download plugins
    #@logger.info('Downloading plugins...')
    for p in config.plugins
      # body...
      plugins.fetchPlugin(p, options)
    #@logger.info('Finished downloading plugins.')
    waituntil(200, 100, ->
      url = config.plugins[config.plugins.length - 1]
      return true if getDirectories("#{retis_plugin_dir}/.tmp/extract").length >= config.plugins.length
      #return true if fs.existsSync "#{retis_plugin_dir}/.tmp/download/"+url.split('/')[url.split('/').length - 1]
      return false
    ,(result) ->
      if result == true
        # body...
        # Execute
        execBuild(config, options, _logger)
    )
  return

getDirectories = (srcpath) ->
  return fs.readdirSync(srcpath).filter (file) ->
    return fs.statSync(path.join(srcpath, file)).isDirectory()
