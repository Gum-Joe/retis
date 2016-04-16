# Installers
###
# Module dependencies
###
npm = require './npm'
###
# Vars
###
installers = module.exports = {}
###
# Installer class
# @param logger {Logger} Logger used
# @param options {Object} Options
###
class Installers

  constructor: (options, loggger) ->
    # body...
    @logger = logger
    @options = options
    @logger.deb('Logger passed to Installers class.')
    @npm = new npm.Npm @options, @logger


# exports
installers.Installers = Installers
