# Build class
###
# Module dependencies
###
os = require 'os'
which = require 'which'
{spawnSync} = require 'child_process'
{spawn} = require 'child_process'
{Installers} = require '../installers/index'
{version} = require '../../package'
{RunScript} = require './script'
{PluginHead} = require '../plugin-head'
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
    # Plugin head logger
    @ph = new PluginHead(@logger)
    # OS
    if !(os.platform() != 'win32' || 'darwin') || (options.hasOwnProperty('os') && typeof options.os != 'undefined' && options.os != 'Windows' && options.os != 'OSX') || (config.hasOwnProperty('os') && config.os != 'Windows' && config.os != 'OSX')
      @os = "Linux"
    if !(os.platform() != 'win32' || 'linux') || (options.hasOwnProperty('os') && typeof options.os != 'undefined' && options.os != 'Windows' && options.os != 'Linux') || (config.hasOwnProperty('os') && config.os != 'Windows' && config.os != 'Linux')
      @os = "OSX"
    if !(os.platform() != 'darwin' || 'linux') || (options.hasOwnProperty('os') && typeof options.os != 'undefined' && options.os != 'OSX' && options.os != 'Linux') || (config.hasOwnProperty('os') && config.os != 'OSX' && config.os != 'Linux')
      @os = "Windows"
    @logger.deb "Initializing default env..."
  ###
  # Install globals
  ###
  installGlobals: () ->
    # Install Here
    # Set globals
    @ph.log "retis-globals", version
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
    @ph.log "retis-script", version
    @logger.info "Generating run script..."
    @script = new RunScript @logger, @options, @config
    @script.applyEnv()
    @script.applyUserEnv()
  ###
  # Check for a property
  # @param prop {String} Property to check for
  # @param value {String} Value to check for
  # @return bolean
  ###
  property: (prop, value) ->
    return typeof @options[prop] != 'undefined' && @options[prop] == value || @config.hasOwnProperty(prop) && @config[prop] == value

  ###
  # Build it
  # @param defaults {String} default
  ###
  build: (defaults) ->
    @logger.deb "Building..."
    # Vars
    @install_cmd = @config.install.split(' ')[0] if @config.hasOwnProperty('install')
    @install_cmd = defaults.install.cmd if not @config.hasOwnProperty('install')
    @install_cmd = which.sync(@install_cmd)
    @install_args = @config.install.substr(@config.install.indexOf(@install_cmd) + 1 + @install_cmd.length).split(' ') if @config.hasOwnProperty('install')
    @install_args = defaults.install.args if not @config.hasOwnProperty('install')
    @ph.log "retis-build", version
    @logger.deb "Exporting env..."
    # Create env
    @_initEnv()
    for env, value of @env
      @logger.deb "#{"export".magenta.bold} #{env}=#{value}"
      process.env[env] = value
    # Install
    @logger.deb "Running install command..."
    @logger.deb "Command: #{@install_cmd.blue.bold}"
    @logger.deb "Args: #{"[".magenta.bold} #{@install_args.toString().replace(/,/g, ', ').green.bold} #{"]".magenta.bold}"
    @logger.running "#{@install_cmd.cyan.bold} #{@install_args.toString().replace(/,/g, ' ').green.bold}"
    _logger = @logger
    @install_output = spawn(@install_cmd, @install_args)
    @install_output.stdout.on('data', (data) ->
      _logger.stdout data.toString 'utf8'
    )
    @install_output.stderr.on('data', (data) ->
      _logger.stderr data.toString 'utf8'
    )

  ###
  # Init env
  # @private
  ###
  _initEnv: ->
    # Init ENV
    @env = {
      RETIS_LANGUAGE: @config.language,
      RETIS_OS: @os
      RETIS_CWD: process.cwd(),
    }
    if @config.hasOwnProperty 'scm'
      throw new Error "No type of scm specified!" if not @config.scm.hasOwnProperty "type"
      throw new Error "Scm \'#{@config.scm.type}\' is not supported!" if @config.scm.type != 'git'
      @env.RETIS_GIT_USER = @config.scm.user.name if @config.scm.hasOwnProperty('user') and @config.scm.user.hasOwnProperty 'name'
      @env.RETIS_GIT_USER =  @_git(['config', 'user.name']) if not @config.scm.hasOwnProperty('user') or not @config.scm.user.hasOwnProperty 'name'
      # Below commands taken from stack Overflow
      # http://stackoverflow.com/questions/949314/how-to-retrieve-the-hash-for-the-current-commit-in-git
      @env.RETIS_GIT_COMMIT = @_git(['rev-parse', 'HEAD'])
      # http://stackoverflow.com/questions/6245570/how-to-get-current-branch-name-in-git
      @env.RETIS_GIT_BRANCH = @_git(['rev-parse', '--abbrev-ref', 'HEAD'])
      # http://stackoverflow.com/questions/4089430/how-can-i-determine-the-url-that-a-local-git-repository-was-originally-cloned-fr
      @env.RETIS_GIT_REMOTE = @_git('config --get remote.origin.url'.split(" "))

      # Add our env
      if @config.hasOwnProperty 'env'
        for env in @config.env
          if not env.includes "="
            # Throw error
            @logger.err "ENV value #{"\'#{env}\'".cyan.bold} not in the form of #{"NAME=VALUE".green.bold}!"
            throw new Error "ENV value \'#{env}\' not in the form of \'NAME=VALUE\'!"
          else
            env_setup = env.split "="
            @env[env_setup[0]] = env_setup[1]
      # CLI
      if typeof @options.props != 'undefined' && @options.props.length > 0
        @logger.deb "Adding cli props..."
        for prop in @options.props
          if prop.startsWith 'env:'
            @logger.deb "Adding #{prop.green.bold}..."
            split_prop = prop.slice(4, prop.length).split('=')
            @env[split_prop[0]] = split_prop[1]


  ###
  # Get git output data
  # @private
  # @param args {Array} git args
  ###
  _git: (args) ->
    return spawnSync('git', args).stdout.toString('utf8').slice(0, -1)
# exports
module.exports = Build: Build
