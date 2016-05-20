# Plugin executer
###
# Module dependencies
###
CSON = require 'cson'
path = require 'path'
fs = require 'fs'
os = require 'os'
Failer = require '../fail'
{PluginHead} = require '../plugin-head'
Api = require './api'
###
# Vars
###
plug = module.exports = {}
###
# Run plugins for a certain type
# @param goal {String} Plugin type
# @param logger {Logger} Logger
###
plug.run = (goal, logger, config) ->
  # Dir for plugins
  plugins_dir = path.join os.homedir(), '.retis', 'plugins'
  # Failer
  fail = new Failer(logger)
  # File with plugins in
  plugins_config = path.join(process.cwd(), '.retis', 'config.cson')
  # Start download
  logger.deb('Running pre-build plgins (before:build)...')
  # Parse plugins
  plugins = CSON.parse(fs.readFileSync(plugins_config))
  # Check for errors
  if plugins instanceof Error
    fail.fail plugins
  # Exec
  logger.deb("Everything #{"OK".green}. Commencing executing...")

  for plug in plugins.packages
    # dir
    plugin_dir = path.join plugins_dir, plug
    # Logger - DEBUG
    logger.deb "Checking plugin #{plug.green} for running..."
    # Parse
    pc = CSON.parse fs.readFileSync(path.join(plugin_dir, 'psf.cson'))
    # Check for errors
    if pc instanceof Error
      fail.fail pc
    # Execute?
    if pc.hasOwnProperty('type') and pc.type == goal
      # Execute
      _exec pc, config, plugin_dir, logger
    else
      logger.deb "Not executing plugin #{plug.green}."

###
# Plugins executer
# @param config {Object} Config
# @param dir {String} dir for plugin
# @param logger {Logger} Logger
# @param fail {Failer} Failer for errors
###
_exec = (pc, config,  dir, logger) ->
  # Plugin head
  head = new PluginHead logger
  # Fix if prop missing
  pc.name = 'retis-plugin' if not pc.hasOwnProperty 'name' or typeof pc.name != 'string'
  pc.version = '0.0.0' if not pc.hasOwnProperty 'version' or typeof pc.version != 'string'
  # Validate
  logger.deb "Executing plugin #{pc.name.green}..."
  logger.deb "Dir: #{dir.cyan}"
  logger.deb "File to require: #{pc.entry.cyan}"
  # Warn
  if not fs.existsSync path.join(dir, pc.entry)
    logger.warn "Plugin #{pc.name.green} does not include its entry file #{pc.entry.cyan}. #{"STOP".red}."
    # Stop
    return
  # Require file
  file = require path.join(dir, pc.entry)
  # Header
  head.log pc.name, pc.version
  # Execute
  # With api
  file new Api(logger, config, pc)

  # Finish with new line
  logger.info ""
