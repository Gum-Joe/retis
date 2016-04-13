# Parse file

###
# Module dependencies
###
fs = require 'fs'
path = require 'path'
YAML = require 'yamljs'
XML = require 'xml2js'
CSON = require 'cson'
{Logger} = require './logger'
require 'colours'
# Vars
parser = module.exports = {}

###
# Parse method
#
# @param options {Object} Options
###
parser.parseConfig = (options) ->
  @logger = new Logger 'redis:parser', options
  @file = '.retis.yml'
  @file = 'retis.json' if fs.existsSync('retis.json')
  @file = 'retis.cson' if fs.existsSync('retis.cson')
  @file = 'psf.json' if fs.existsSync('psf.json')
  @file = 'psf.cson' if fs.existsSync('psf.cson')
  # File?
  if typeof options.file != 'undefined'
    # File specified
    @logger.deb('A file was already specified.')
    @logger.deb("File: #{"\'#{options.file}\'".green}")
    @file = options.file
    # body...

  # Check if exists
  @logger.deb("Parseing build specification file #{@file}...")
  @logger.deb('Checking if file exists...')
  fs.stat(@file, (err, stat) ->
    if err
      @logger.info('Error parsing build specification file!')
      throw err
    if stat.isDirectory()
      @logger.info('File specified was a directory and not a file!')
      throw new Error('File was a directory and not a file!')
  )
  @logger.deb('Found file. Parsing')
  @file_suffix = path.extname(@file)
  @logger.deb("File Extension: #{"\'#{@file_suffix}\'".green}")
  if @file_suffix == ".yml"
    # Parse using yaml-js
    @logger.deb('Parsing using npm module \'yamljs\'...')
    return YAML.load path.join(process.cwd(), @file)
  else if @file_suffix == ".json"
    # Parse using built in json
    @logger.deb('Parsing using nodejs\'s json parser...')
    return require path.join process.cwd(), @file
  else if @file_suffix == ".cson"
    # Parse using yaml-js
    @logger.deb('Parsing using npm module \'cson\'...')
    return CSON.parse fs.readFileSync(path.join(process.cwd(), @file))
  else
    # Unregonised
    throw new TypeError 'Type of build specification file was not reconised.'
