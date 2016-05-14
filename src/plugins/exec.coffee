# Plugin executer
###
# Module dependencies
###
CSON = require 'cson'
path = require 'path'
fs = require 'fs'
Failer = require '../fail'
###
# Vars
###
plug = module.exports = {}
###
# Run pre-build plugins
# @param logger {Logger} Logger
###
plug.runPrebuild = (logger) ->
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
