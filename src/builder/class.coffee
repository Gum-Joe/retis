# Build class
###
# Module dependencies
###
{Installers} = require '../installers/index'
###
# Build class
# @param config {Object} config
# @param options {Object} Options from cli
# @param logger {Logger} logger
###
class Build
  # Extended by all engines
  constructor: (config, options, logger) ->
    @config  = config
    @logger = logger
    @options = options
    @logger.deb('Logger passed to Build class.')
    # Installers (package managers)
    @installers = new Installers @options, @logger
  ###
  # Install globals
  ###
  installGlobals: () ->
    # Install Here
    # Set globals
    @global_deps = @config.global
    @logger.info('Getting global dependencies...')
    if @global_deps.hasOwnProperty 'npm'
      @logger.info('Getting npm globals...')
      @installers.npm.install(@global_deps.npm, global: true)
    return


# exports
module.exports = Build: Build
