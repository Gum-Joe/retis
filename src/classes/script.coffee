# Class for runtime script
###
# Module dependencies
###
mkdirp = require 'mkdirp'
fs = require 'fs'
os = require 'os'
{validateOS} = require '../os'
{spawnSync} = require 'child_process'
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
    ###
    # Linux/OSX/FreeBSD header
    if (os.platform() != 'win32') || (config.hasOwnProperty('os') && config.os != 'Windows') || (options.hasOwnProperty('os') && typeof options.os != 'undefined' && options.os != 'Windows')
      @sh_header = '#!/bin/bash'
      @sh_suffix = '.sh'
    if (os.platform() == 'win32') || (config.hasOwnProperty('os') && config.os == 'Windows') || (options.hasOwnProperty('os') && typeof options.os != 'undefined' && options.os == 'Windows')
      @sh_header = '@echo off\nREM Windows file to run builds\n@echo on'
      @sh_suffix = '.cmd'
    ###
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
    @logger.deb "Apply ENV to run script..."
    if @sh_config.hasOwnProperty("hide_env") && @sh_config.hide_env == false || !(@sh_config.hasOwnProperty("hide_env"))
      @logger.deb "Exportion hidden by user."
      @echo "Setting environment variables..."
    @addEnv "RETIS_LANGUAGE", @config.language
    @addEnv "RETIS_OS", @os
    @addEnv "RETIS_PROJECT_NAME", @options.name
    @addEnv "RETIS_GIT_USER", spawnSync('git', ['config', 'user.name']).stdout.toString('utf8')
    @logger.deb "Applied ENV to run script."
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
      @echo("#{@export_key_word} #{env}")
    @write("#{@export_key_word} #{env}=\"#{value}\"")
  ###
  # ECHO command
  # @param str {String} String to echo
  ###
  echo: (str) ->
    @write "echo #{str}"
  ###
  # Write to script
  # @param data {String} String to write
  ###
  write: (data) ->
    @file.write "#{data}\n"

# Export
script.RunScript = RunScript
