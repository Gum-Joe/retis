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

  constructor: (logger, config) ->
    @logger = logger
    @package = config
    @args = logger.options

# Export
module.exports = Api
