# File for fetching plugins
###
# Module dependencies
###
{Logger} = require './logger'
fs = require 'fs'
path = require 'path'
os = require 'os'
mkdirp = require 'mkdirp'
urlm = require 'url'
{get} = require('./downloader')
downloadList = require './plugins/donwloadList'
unpacker = require './plugins/unpacker'
###
# Vars
###
plugins = module.exports = {}
retis_plugin_dir = '.retis/plugins'
retis_plugin_dir = path.join(os.homedir(), retis_plugin_dir)

###
# Download method
# @param url {String} URL to download
# @param options {Object} Options
# @param callback {Function} callback
###
plugins.fetchPlugin = (url, options, callback) ->
  # Create logger object
  logger = new Logger('retis', options)
  logger.deb('Downloading plugin...')
  file_save = "#{retis_plugin_dir}/.tmp/download/"+url.split('/')[url.split('/').length - 2]+'.cson'
  if downloadList.check(url, options) && typeof options.force == 'undefined' && fs.existsSync file_save
    # body...
    logger.deb("Skipping plugin from url #{url}...")
    callback()
    return
  # Download
  @download_options =
    hostname: urlm.parse(url).hostname
    path: urlm.parse(url).path
    method: 'GET'
  # Make req
  get(url, file_save, options, (err) ->
    throw err if err
    #logger.info("Extracting #{url.split('/')[url.split('/').length - 1]} from #{url}...")
    # Add to list
    logger.deb('Adding to download list...')
    downloadList.add(url, options)
    unpacker.unpack(file_save, options, logger, (err) ->
      throw err if err
      callback()
    )
  )
  return
