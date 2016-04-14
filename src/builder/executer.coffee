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
  engines.nodejs.start(config, options, logger) if language == 'nodejs'
