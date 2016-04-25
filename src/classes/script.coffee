# Class for runtime script
###
# Module dependencies
###
mkdirp = require 'mkdirp'
fs = require 'fs'
os = require 'os'
{validateOS} = require '../os'
{spawnSync} = require 'child_process'
{spawn} = require 'child_process'
###
# Vars
###
script = module.exports = {}
###
# Class
# @param logger {Logger} Logger
# @param options {Object} Options
# @param config {Object} CSON/JSON/YAML parsed config
# @param callback {Function} Callback
###
class RunScript

  constructor: (logger, options, config, callback) ->
    # Headers
    # Vars
    @config = config
    @logger = logger
    @options = options
    if !(os.platform() != 'win32' || 'darwin') || (options.hasOwnProperty('os') && typeof options.os != 'undefined' && options.os != 'Windows' && options.os != 'OSX') || (config.hasOwnProperty('os') && config.os != 'Windows' && config.os != 'OSX')
      @os = "Linux"
    if !(os.platform() != 'win32' || 'linux') || (options.hasOwnProperty('os') && typeof options.os != 'undefined' && options.os != 'Windows' && options.os != 'Linux') || (config.hasOwnProperty('os') && config.os != 'Windows' && config.os != 'Linux')
      @os = "OSX"
    if !(os.platform() != 'darwin' || 'linux') || (options.hasOwnProperty('os') && typeof options.os != 'undefined' && options.os != 'OSX' && options.os != 'Linux') || (config.hasOwnProperty('os') && config.os != 'OSX' && config.os != 'Linux')
      @os = "Windows"
    validateOS(@os, @logger)
    # Headers + script setup
    @sh_header = '#!/bin/bash\n' if @os != 'Windows'
    @sh_header = '@echo off\nREM Windows file to run builds\n@echo on\n' if @os == 'Windows'
    @sh_suffix = '.sh' if @os != 'Windows'
    @sh_suffix = '.cmd' if @os == 'Windows'
    @sh_config = config.sh if config.hasOwnProperty "sh"
    @sh_config = {} if not config.hasOwnProperty "sh"
    # More vars
    @build_output = "./build"
    @build_output = config.out_dir if config.hasOwnProperty 'out_dir'
    @build_output = options.outDir if options.hasOwnProperty 'outDir' && typeof options.outDir != 'undefined'
    @run_script = "#{@build_output}/build#{@sh_suffix}"
    @run_key = "[RUN]".green.bold
    # Create build dir if none
    @logger.deb "Build output directory: #{@build_output.cyan.bold}"
    if not fs.existsSync @build_output
      # body...
      @logger.deb "Creating output directory #{@build_output.cyan.bold}..."
      mkdirp @build_output
      @logger.deb "Created output directory #{@build_output.cyan.bold}."
    # Create run script
    @logger.deb "Creating run script #{@run_script.cyan.bold}..."
    @file = fs.createWriteStream @run_script, {flags: 'w+', defaultEncoding: 'utf8'}
    @file.write @sh_header
    @logger.deb "New run script created."
    return
  # Methods
  ###
  # Add ENVs
  ###
  applyEnv: ->
    @logger.deb "Applying ENV to run script..."
    if @sh_config.hasOwnProperty("hide_env") && @sh_config.hide_env == false || !(@sh_config.hasOwnProperty("hide_env"))
      @echo "Setting environment variables...".green.bold
    else
      @logger.deb "Exportion hidden by user."
    @addEnv "RETIS_LANGUAGE", @config.language
    @addEnv "RETIS_OS", @os
    @addEnv "RETIS_PROJECT_NAME", @options.name
    if @config.hasOwnProperty 'scm'
      throw new Error "No type of scm specified!" if not @config.scm.hasOwnProperty "type"
      throw new Error "Scm \'#{@config.scm.type}\' is not supported!" if @config.scm.type != 'git'
      @addEnv "RETIS_GIT_USER", @config.scm.user.name if @config.scm.hasOwnProperty('user') and @config.scm.user.hasOwnProperty 'name'
      @addEnv "RETIS_GIT_USER", @_git(['config', 'user.name']) if not @config.scm.hasOwnProperty('user') or not @config.scm.user.hasOwnProperty 'name'
      # Below commands taken from stack Overflow
      # http://stackoverflow.com/questions/949314/how-to-retrieve-the-hash-for-the-current-commit-in-git
      @addEnv "RETIS_GIT_COMMIT", @_git(['rev-parse', 'HEAD'])
      # http://stackoverflow.com/questions/6245570/how-to-get-current-branch-name-in-git
      @addEnv "RETIS_GIT_BRANCH", @_git(['rev-parse', '--abbrev-ref', 'HEAD'])
      # http://stackoverflow.com/questions/4089430/how-can-i-determine-the-url-that-a-local-git-repository-was-originally-cloned-fr
      @addEnv "RETIS_GIT_REMOTE", @_git('config --get remote.origin.url'.split(" "))
    @echo ""
    @logger.deb "Applied ENV to run script."
    return
  ###
  # Add User ENVs
  ###
  applyUserEnv: ->
    if @config.hasOwnProperty "env"
      @logger.deb "Adding user env to script..."
      @echo "Settting environment variables from project specification file...".green.bold if @sh_config.hasOwnProperty("hide_env") && @sh_config.hide_env == false || !(@sh_config.hasOwnProperty("hide_env"))
      for env in @config.env
        # env.includes() usage + finding out about it from http://stackoverflow.com/questions/1789945/how-can-i-check-if-one-string-contains-another-substring
        if not env.includes "="
          @logger.err "ENV value #{"\'#{env}\'".cyan.bold} not in the form of #{"NAME=VALUE".green.bold}!"
          throw new Error "ENV value \'#{env}\' not in the form of \'NAME=VALUE\'!"
        env_split = env.split "="
        @addEnv env_split[0], env_split[1]
  ###
  # Add single ENV
  # @param env {String} Variable to set
  # @param value {String} Value
  ###
  addEnv: (env, value) ->
    @logger.deb "Adding environmet variable #{env.magenta.bold}..."
    @export_key_word = 'export' if @os != 'Windows'
    @export_key_word = 'set' if @os == 'Windows'
    if @sh_config.hasOwnProperty("hide_env") && @sh_config.hide_env == false || !(@sh_config.hasOwnProperty("hide_env"))
      @echo("#{@export_key_word.magenta.bold} #{env}")
    @write("#{@export_key_word} #{env}=\"#{value}\"")
  ###
  # ECHO command
  # @param str {String} String to echo
  ###
  echo: (str) ->
    @write "echo #{str}"
  ###
  # Add command
  # @param cmd {String} Command
  ###
  add: (cmd) ->
    # Error check
    # From: http://www.cyberciti.biz/faq/shell-how-to-determine-the-exit-status-of-linux-and-unix-command/
    @error_check = "#{cmd} || {\n\techo #{"Command \"#{cmd}\" exited with $?".bold}\n\texit $?\n}"
    @logger.deb "Adding command #{"\'#{cmd}\'".cyan.bold}..."
    @echo("#{@run_key} #{cmd}") if @sh_config.hasOwnProperty("hide_env") && @sh_config.hide_env == false || !(@sh_config.hasOwnProperty("hide_env"))
    @write "#{@error_check}"
  ###
  # Run script
  ###
  runScript: ->
    # Run
    @logger.deb "Running script #{@run_script}..."
    if not @os == 'Windows'
      @output = spawn 'bash', [ @run_script ]
    else
      @output = spawn 'cmd', [ @run_script ]
    @output.stdout.on 'data', (data) ->
      # Log stdout
      @logger.stdout data.toString 'utf8'
    @output.stderr.on 'data', (data) ->
      # Log stdout
      @logger.stderr data.toString 'utf8'
    @output.on 'exit', (code) ->
      @logger.deb "Script exited with #{code}"
      if code != 0
        @logger.err "Script exited with #{code.yellow.bold}!"
        throw new Error "Script exited with #{code}!"
  ###
  # Write to script
  # @param data {String} String to write
  ###
  write: (data) ->
    @file.write "#{data}\n"
  ###
  # Get git output data
  # @private
  # @param args {Array} git args
  ###
  _git: (args) ->
    return spawnSync('git', args).stdout.toString('utf8').slice(0, -1)

# Export
script.RunScript = RunScript
