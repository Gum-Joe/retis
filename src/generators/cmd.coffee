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
    tmp_ret = @config[property].split(' ')[0] if @config.hasOwnProperty(property)
    tmp_ret = @defaults[property].cmd if not @config.hasOwnProperty(property) and @defaults.hasOwnProperty property
    return which(tmp_ret) if typeof tmp_ret != 'undefined'
    return null if typeof tmp_ret == 'undefined'
  ###
  # Get args
  # @param property {String} Property to find in config
  ###
  args: (property) ->
    tmp_build_args = @config[property].split(' ') if @config.hasOwnProperty(property)
    if @config.hasOwnProperty(property)
      new_build_args = []
      for arg in tmp_build_args
        if arg != tmp_build_args[0]
          new_build_args.push arg
        if arg == tmp_build_args[tmp_build_args.length - 1]
          tmp_build_args = new_build_args
    tmp_build_args = @defaults.build.args if not @config.hasOwnProperty(property) and @defaults.hasOwnProperty property
    return tmp_build_args if typeof tmp_build_args != 'undefined'
    return null if typeof tmp_build_args == 'undefined'

# Export
module.exports = Command
