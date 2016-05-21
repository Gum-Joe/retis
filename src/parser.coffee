# Parse file

###
# Module dependencies
###
fs = require 'fs'
path = require 'path'
YAML = require 'yamljs'
CSON = require 'cson'
{Logger} = require './logger'
Failer = require './fail'
require 'colours'
# Vars
parser = module.exports = {}

###
# Parse method
#
# @param options {Object} Options
###
parser.parseConfig = (options, callback) ->
  # Logger
  @logger = new Logger 'retis', options
  # Failer
  fail = new Failer(@logger)
  # Files
  file = '.retis.yml'
  file = 'retis.json' if fs.existsSync('retis.json')
  file = 'retis.cson' if fs.existsSync('retis.cson')
  file = 'psf.json' if fs.existsSync('psf.json')
  file = 'psf.cson' if fs.existsSync('psf.cson')
  # File?
  if typeof options.file != 'undefined'
    # File specified
    @logger.deb('A file was already specified.')
    @logger.deb("File: #{"\'#{options.file}\'".green}")
    file = options.file
    # body...
  # Check if exists
  @logger.deb("Parseing build specification file #{file}...")
  @logger.deb('Checking if file exists...')
  # Fix logger not available
  _logger = @logger
  stat = fs.statSync(file)
  if stat.isDirectory()
    fail.fail new Error('File was a directory and not a file!')

  # Parse
  @logger.deb('Found file. Parsing')
  file_suffix = path.extname(file)
  @logger.deb("File Extension: #{"\'#{file_suffix}\'".green}")
  if file_suffix == ".yml"
    # Parse using yaml-js
    @logger.deb('Parsing using npm module \'yamljs\'...')
    return YAML.load path.join(process.cwd(), file)
  else if file_suffix == ".json"
    # Parse using built in json
    @logger.deb('Parsing using nodejs\'s json parser...')
    return require path.join process.cwd(), file
  else if file_suffix == ".cson"
    # Parse using yaml-js
    @logger.deb('Parsing using npm module \'cson\'...')
    return_val = CSON.parse fs.readFileSync(path.join(process.cwd(), file))
    if return_val instanceof Error
      @logger.deb "Error parsing project specification!"
      err = new Error("Error parsing project specification: #{return_val}")
      err.stack = return_val.stack
      fail.fail(err)
    return return_val
  else
    # Unregonised
    if typeof callback != 'undefined'
      return new TypeError 'Type of build specification file was not reconised.'
    else
      fail.fail new TypeError 'Type of build specification file was not reconised.'
      return
