# API
###
# Module dependencies
###

###
# Vars
###

###
# Class
# @param logger {Logger} Logger to use
# @param config {Object} Plugin config
###
class Api

  constructor: (logger, config, pc) ->
    # Logger
    @logger = logger
    # Package config
    @config = config
    # Plugin config
    @pc = pc
    @args = logger.options

# Export
module.exports = Api
