# Build file for retis

# Module dependencies
{Logger} = require './logger'
fs = require 'fs'
{parseConfig} = require './parser'
# Vars
app = module.exports = {}

###
# Build method
# @param options {Object} Options
###
app.build = (options) ->
  @logger = new Logger('retis', options)
  @logger.info('Scanning for build specification...')
  @logger.deb("CWD: #{"\'#{options.dir}\'".green}") if typeof options.dir != 'undefined'
  parseConfig(options)

  return
