# File to detect warnings
###
# Module dependencies
###
require 'colours'
{Logger} = require './logger'
###
# Vars
###
warn = module.exports = {}
###
# Warning method
# @param config {Object} CSON file of config
# @param logger {Logger} Logger
###
warn.warnings = (config, options, logger) ->
  logger.deb "Checking if everything is #{"OK".green.bold}..."
  if typeof options.local != 'undefined' && options.local == true || config.hasOwnProperty('local') && config.local == true
    # body...
    _localWarnings(config, logger)
  return

###
# Local warnings method
# @param config {Object} CSON file of config
# @param logger {Logger} Logger
# @private
###
_localWarnings = (config, logger) ->
  # NVM
  if config.hasOwnProperty 'nvm'
    # body...
    logger.warn 'NVM versioning is not supported on local builds.'
  # RVM
  if config.hasOwnProperty 'rvm'
    # body...
    logger.warn 'RVM versioning is not supported on local builds.'
