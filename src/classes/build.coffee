# Build class
###
# Module dependencies
###
os = require 'os'
which = require '../which'
generators = require '../generators'
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
    cmd = new generators.Command(@config, defaults, @logger)
    # Vars
    # Install
    @install_cmd = cmd.generate('install')
    #@install_cmd = @config.install.split(' ')[0] if @config.hasOwnProperty('install')
    #@install_cmd = defaults.install.cmd if not @config.hasOwnProperty('install')
    # Get cmd
    @install_cmd = which(@install_cmd)
    # Args
    @install_args = @config.install.split(' ') if @config.hasOwnProperty('install')
    if @config.hasOwnProperty('install')
      new_install_args = []
      for arg in @install_args
        if arg != @install_args[0]
          new_install_args.push arg
        if arg == @install_args[@install_args.length - 1]
          @install_args = new_install_args
    @install_args = defaults.install.args if not @config.hasOwnProperty('install')

    # Build stuff
    @build_cmd = @config.build.split(' ')[0] if @config.hasOwnProperty('build')
    @build_cmd = defaults.build.cmd if not @config.hasOwnProperty('build')
    # Get cmd
    @build_cmd = which(@build_cmd)
    # Args
    @build_args = @config.build.split(' ') if @config.hasOwnProperty('build')
    if @config.hasOwnProperty('build')
      new_build_args = []
      for arg in @build_args
        if arg != @build_args[0]
          new_build_args.push arg
        if arg == @build_args[@build_args.length - 1]
          @build_args = new_build_args
    @build_args = defaults.build.args if not @config.hasOwnProperty('build')

    @ph.log "retis-build", version
    @logger.deb "Exporting env..."
    # Create env
    @_applyEnv()
    # Install
    @logger.info "Running install command..."
    @exec(@install_cmd, @install_args)
    @logger.info ""
    @logger.info "Running build command..."
    @exec(@build_cmd, @build_args)
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
  # Execute
  # @param cmd {String} Command to execute
  # @param args {Array} Array of args
  ###
  exec: (cmd, args) ->
    @logger.deb "Command: #{cmd.blue.bold}"
    @logger.deb "Args: #{"[".magenta.bold} #{args.toString().replace(/,/g, ', ').green.bold} #{"]".magenta.bold}"
    @logger.running "#{cmd.cyan.bold} #{args.toString().replace(/,/g, ' ').green.bold}"
    _logger = @logger
    # Create process
    @output = spawnSync(cmd, args)
    # Errors
    if @output.error
      err = @output.error
      if err.code == "ENOENT"
        err.message = "Command \'#{cmd}\' not found!"
      @fail(err)
    @logger.stdout "Output:" if @options.hasOwnProperty('showOutput') && @options.showOutput == true
    @logger.stdout "" if @options.hasOwnProperty('showOutput') && @options.showOutput == true
    # Output
    # Stdout
    for stdout in @output.stdout.toString('utf8').split('\n')
      @logger.stdout stdout if @options.hasOwnProperty('showOutput') && @options.showOutput == true
    # Stderr
    for stderr in @output.stderr.toString('utf8').split('\n')
      @logger.stderr stderr if @options.hasOwnProperty('showOutput') && @options.showOutput == true
    # Check exit
    @logger.info ""
    @logger.info "Process exited with #{@output.status.toString().yellow.bold}."
    if @output.status > 0
      err_string = "Command #{"\'".cyan.bold}#{cmd.cyan.bold} #{args.toString().replace(/,/g, ' ').cyan.bold}#{"\'".cyan.bold} exited with #{@output.status.toString().yellow.bold}!"
      @logger.err err_string
      @logger.err ""
      @fail new Error "Command \'#{cmd} #{args.toString().replace(/,/g, ' ')}\' exited with #{@output.status}!"

  ###
  # Fail build
  # @param err {Error} Error to fail with
  ###
  fail: require '../fail'

  ###
  # Get git output data
  # @private
  # @param args {Array} git args
  ###
  _git: (args) ->
    return spawnSync('git', args).stdout.toString('utf8').slice(0, -1)

  ###
  # Apply env
  ###
  _applyEnv: ->
    @_initEnv()
    for env, value of @env
      @logger.deb "#{"export".magenta.bold} #{env}=#{value}"
      process.env[env] = value
# exports
module.exports = Build: Build
