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
  log: (plugin, version, options) ->
    prefix = options.prefix if typeof options != 'undefined' and options.hasOwnProperty('prefix')
    prefix = " " if typeof options == 'undefined' or not options.hasOwnProperty('prefix')
    suffix = options.suffix if typeof options != 'undefined' and options.hasOwnProperty('suffix')
    suffix = " " if typeof options == 'undefined' or not options.hasOwnProperty('suffix')
    @logger.info("#{prefix}----------------------------- #{plugin}@#{version} -----------------------------#{suffix}")
    @logger.info "" if typeof options == 'undefined' or not options.hasOwnProperty('noSpace') or not options.noSpace

# Export
ph.PluginHead = PluginHead
