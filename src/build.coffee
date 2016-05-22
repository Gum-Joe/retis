# Build file for retis

# Module dependencies
{Logger} = require './logger'
path = require 'path'
{parseConfig} = require './parser'
plugins = require './plugins'
mkdirs = require './mkdirs'
os = require 'os'
{execBuild} = require './builder/executer'
async = require 'async'
warn = require './warnings'
# Vars
app = module.exports = {}
retis_plugin_dir = '.retis/plugins'
retis_plugin_dir = path.join(os.homedir(), retis_plugin_dir)
plugins_func = []

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
  options.name = @name[@name.length - 1] if config.hasOwnProperty('name') == false
  options.name = @name if config.hasOwnProperty('name')
  _logger.deb("Received config from parser.")
  _logger.deb("Starting build...")
  # Begin build
  #_logger.info("")
  warn.warnings(config, options, _logger)
  #_logger.info(":---------------------------------------------:")
  _logger.info("Building Project \'#{@name[@name.length - 1]}\'...") if config.hasOwnProperty('name') == false
  _logger.info("Building Project \'#{@name}\'...") if config.hasOwnProperty('name') == true
  #_logger.info(":---------------------------------------------:")
  _logger.info("")
  mkdirs(_logger)
  # Check for plugins
  if config.hasOwnProperty 'plugins'
    # body...
    # Download plugins
    for p in config.plugins
      # body...
      plugins_func.push ->
        plugins.fetchPlugin(p, options, ->
          if p == config.plugins[config.plugins.length - 1]
            execBuild(config, options, _logger)
          else
            return
        )
    async.series(plugins_func)
  return
