# Parse file

###
# Module dependencies
###
fs = require 'fs'
path = require 'path'
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
  @file = "#{options.dir}/.retis.yml" if typeof options.dir != 'undefined'
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
  @logger.deb('Found file. Parsing...')
  @file_suffix = path.extname(@file)
  @logger.deb("File Extension: #{"\'#{@file_suffix}\'".green}")
