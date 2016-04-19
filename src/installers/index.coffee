# Installers
###
# Module dependencies
###
npm = require './npm'
gem = require './gem'
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
    @gem = new gem.Gem @options, @logger


# exports
installers.Installers = Installers
