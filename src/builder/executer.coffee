# Execute build
###
# Module dependencies
###
engines = require './engines/index'
require 'colours'
###
# Vars
###
builder = module.exports = {}

###
# Execute method
###
builder.execBuild = (config, options, logger) ->
  # Here we build
  language = config.language
  logger.deb('Starting build for the correct language.')
  logger.deb("Language: #{"\'#{config.language}\'".green}")
  new engines.nodejs.Builder(config, options, logger).start() if language == 'nodejs'
