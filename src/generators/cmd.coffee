# Generate CMD
###
# Module dependencies
###
which = require '../which'
###
# Vars
###
gen = module.exports = {}
###
# Gen cmd
# @param config {Object} config
# @param defaults {Object} Defaults for cmd
# @param logger {Logger} Logger
###
class Command # extends GlobalConfig

  constructor: (config, defaults, logger) ->
    @config = config
    @logger = logger
    @defaults = defaults

  ###
  # Generate
  # @param property {String} Property to find in config
  ###
  generate: (property) ->
    return @config[property].split(' ')[0] if @config.hasOwnProperty(property)
    return defaults[property].cmd if not @config.hasOwnProperty(property)

# Export
module.exports = Command
