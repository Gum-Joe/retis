# Index of nodejs engine + methods
###
# Module dependencies
###

###
# Vars
###
engine = module.exports = {}

# Engine method
engine.start = (config, options, logger) ->
  if typeof options.local != 'undefined' && options.local == true || config.hasOwnProperty('local') && config.local == true
    # body...
    # No need for a bash script
    if config.hasOwnProperty 'nvm'
      # body...
      logger.warn 'NVM versioning is not supported on local builds.'
    logger.info('Running a local build...')
    # Gets globals
    if config.hasOwnProperty 'global'
      # body...
      logger.info('Getting global dependencies...')
      if config.global.hasOwnProperty 'npm'
        logger.info('Getting npm globals...')
        npm_globals = config.global.npm.toString()
        logger.info npm_globals
  else
    ###
    # Create bash script
    # @docker only
    ###
    logger.deb('Generating bash script...')
