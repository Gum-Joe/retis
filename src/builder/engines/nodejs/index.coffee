# Index of nodejs engine + methods
###
# Module dependencies
###
{Build} = require '../../class'
###
# Vars
###
engine = module.exports = {}
###
# Engine class
# @extends build
# @class
###
class Builder extends Build
  start: () ->
    if typeof @options.local != 'undefined' && @options.local == true || @config.hasOwnProperty('local') && @config.local == true
      # body...
      # No need for a bash script
      if @config.hasOwnProperty 'nvm'
        # body...
        @logger.warn 'NVM versioning is not supported on local builds.'
      @logger.info('Running a local build...')
      # Gets globals
      if @config.hasOwnProperty 'global'
        @installGlobals()
    else
      ###
      # Create bash script
      # @docker only
      ###
      @logger.deb('Generating bash script...')

engine.Builder = Builder
