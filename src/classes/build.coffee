# Build class
###
# Module dependencies
###
{Installers} = require '../installers/index'
{version} = require '../../package'
{RunScript} = require './script'
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
      console.log ''
      @logger.deb('Getting npm (nodejs) globals...')
      @installers.npm.install(@global_deps.npm, global: true)
    if @global_deps.hasOwnProperty 'gem'
      console.log ''
      @logger.deb('Getting gem (ruby) globals...')
      @installers.gem.install(@global_deps.gem)
    if @global_deps.hasOwnProperty 'pip'
      console.log ''
      @logger.deb('Getting pip (python) globals...')
      @installers.pip.install(@global_deps.pip)
    return
  ###
  # Create script
  ###
  createScript: ->
    @logger.info("")
    @logger.info " -----------------------------: retis-script@#{version} :----------------------------- "
    @logger.info "Generating run script..."
    @script = new RunScript @logger, @options, @config
    @script.applyEnv()
    @script.applyUserEnv()


# exports
module.exports = Build: Build
