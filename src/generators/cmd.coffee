# Generate CMD
###
# Module dependencies
###
which = require '../which'
###
# Vars
###

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
    if typeof @config[property] == 'string'
      # String
      tmp_ret = @config[property].split(' ')[0] if @config.hasOwnProperty(property)
    else if not @config.hasOwnProperty(property)
      tmp_ret = @defaults[property].cmd if not @config.hasOwnProperty(property) and @defaults.hasOwnProperty property
    else
      tmp_ret = []
      for ret in @config[property]
        tmp_ret.push(which(ret.split(' ')[0]))

    return which(tmp_ret) if typeof tmp_ret != 'undefined' && typeof tmp_ret == 'string'
    return tmp_ret if typeof tmp_ret != 'undefined' && typeof tmp_ret != 'string'
    return null if typeof tmp_ret == 'undefined'
  ###
  # Get args
  # @param property {String} Property to find in config
  ###
  args: (property) ->
    if @config.hasOwnProperty(property) and typeof @config[property] == 'string'
      tmp_build_args = @config[property].split(' ')
      new_build_args = []
      for arg in tmp_build_args
        if arg != tmp_build_args[0]
          new_build_args.push arg
        if arg == tmp_build_args[tmp_build_args.length - 1]
          tmp_build_args = new_build_args
    else if @config.hasOwnProperty(property) and typeof @config[property] == 'object'
      # array
      tmp_build_args = []
      i = 0
      while i < @config[property].length
        # Add
        tmp_build_args.push []
        for arg in @config[property][i].split ' '
          tmp_build_args[i].push arg if arg != @config[property][i].split(' ')[0]
        i++

    tmp_build_args = @defaults.build.args if not @config.hasOwnProperty(property) and @defaults.hasOwnProperty property
    return tmp_build_args if typeof tmp_build_args != 'undefined'
    return null if typeof tmp_build_args == 'undefined'

# Export
module.exports = Command
