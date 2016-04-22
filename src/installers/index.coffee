# Installers
###
# Module dependencies
###
{Npm} = require './npm'
{Gem} = require './gem'
{Pip} = require './pip'
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
    @npm = new Npm @options, @logger
    @gem = new Gem @options, @logger
    @pip = new Pip @options, @logger


# exports
installers.Installers = Installers
