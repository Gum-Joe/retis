# Plugin head logger
###
# Vars
###
ph = module.exports = {}
###
# Log header
# @class
# @param logger {Logger} Logger
###
class PluginHead

  constructor: (logger) ->
    @logger = logger
  ###
  # Log it
  # @param plugin {String} Plugin name
  # @param version {String} Version
  ###
  log: (plugin, version) ->
    @logger.info(" -----------------------------: #{plugin}@#{version} :----------------------------- ")
    console.log ""

# Export
ph.PluginHead = PluginHead
