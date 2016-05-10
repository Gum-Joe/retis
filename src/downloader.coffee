# Downloader
###
# Module dependencies
###
request = require 'request'
progress = require 'request-progress'
{Logger} = require './logger'
fs = require 'fs'
require 'colours'

# Vars
downloader = module.exports = {}

###
# Downloader
# @param url {String} url to GET
# @param save {String} Save file
# @param options {Object} Options
# @param callback {Function} Callback
###
downloader.get = (url, save, options, callback) ->
  log = require('single-line-log').stdout
  # Download
  # Logger
  logger = new Logger('retis', options)
  # If silent, no log()
  if options.hasOwnProperty('silent') and options.silent
    log = () ->
      # Do nothing
  # File stream
  file_stream = fs.createWriteStream(save)
  log("#{"[retis INFO]".green} Downloading #{url}...0% at 0 kb/sec...\n")
  progress(request(url))
    .on('progress', (state) ->
      percent = "#{Math.floor(state.percentage * 100)}% [#{Math.round(state.size.transferred / 1024)} kb of #{Math.round(state.size.total / 1024)} kb]"
      log("#{"[retis INFO]".green} Downloading #{url}...#{percent} at #{Math.round(state.speed / 1024)} kb/sec...\n")
    )
    .on('data', (d) ->
      file_stream.write d
      return
    )
    .on 'error', (e) ->
      callback(e)
      return
    .on 'end', () ->
      log("#{"[retis INFO]".green} Downloading #{url}...100%\n")
      logger.info("Downloaded #{url}.\n")
      callback()
      return
  return
