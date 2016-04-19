# File for fetching plugins
###
# Module dependencies
###
{Logger} = require './logger'
fs = require 'fs'
path = require 'path'
os = require 'os'
mkdirp = require 'mkdirp'
request = require 'request'
{https} = require('follow-redirects')
fs = require('fs')
urlm = require 'url'
unzip = require 'unzip'
zlib = require 'zlib'
targz = require 'tar.gz'
log = require('single-line-log').stdout
{get} = require('./downloader')
downloadList = require './plugins/donwloadList'
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
###
plugins.fetchPlugin = (url, options) ->
  # Create logger object
  logger = new Logger('retis', options)
  logger.deb('Downloading plugin...')
  logger.deb("Creating dir #{retis_plugin_dir}...")
  mkdirp(retis_plugin_dir, (err) ->
    throw err if err
  ) if fs.existsSync(retis_plugin_dir) == false
  logger.deb("Created dir #{retis_plugin_dir}.")
  # TMP
  logger.deb("Creating dir #{retis_plugin_dir}/.tmp...")
  mkdirp("#{retis_plugin_dir}/.tmp", (err) ->
    throw err if err
  ) if fs.existsSync("#{retis_plugin_dir}/.tmp") == false
  logger.deb("Created dir #{retis_plugin_dir}/.tmp.")
  # tmp/donwload
  logger.deb("Creating dir #{retis_plugin_dir}/.tmp/download...")
  mkdirp("#{retis_plugin_dir}/.tmp/download", (err) ->
    throw err if err
  ) if fs.existsSync("#{retis_plugin_dir}/.tmp/download") == false
  logger.deb("Created dir #{retis_plugin_dir}/.tmp/download.")
  # tmp/extracts
  logger.deb("Creating dir #{retis_plugin_dir}/.tmp/extract...")
  mkdirp("#{retis_plugin_dir}/.tmp/extract", (err) ->
    throw err if err
  ) if fs.existsSync("#{retis_plugin_dir}/.tmp/extract") == false
  logger.deb("Created dir #{retis_plugin_dir}/.tmp/extract.")
  # plugins/.config
  logger.deb("Creating dir #{retis_plugin_dir}/.config/...")
  mkdirp("#{retis_plugin_dir}/.config/", (err) ->
    throw err if err
  ) if fs.existsSync("#{retis_plugin_dir}/.config/") == false
  logger.deb("Created dir #{retis_plugin_dir}/.config/.")
  if downloadList.check(url, options) && typeof options.force == 'undefined'
    # body...
    logger.deb("Skipping plugin from url #{url}...")
    return;
  # Download
  @download_options =
    hostname: urlm.parse(url).hostname
    path: urlm.parse(url).path
    method: 'GET'
  file_save = "#{retis_plugin_dir}/.tmp/download/"+url.split('/')[url.split('/').length - 1]
  # Make req
  get(url, file_save, @download_options, (err) ->
    throw err if err
    #logger.info("Extracting #{url.split('/')[url.split('/').length - 1]} from #{url}...")
    # Add to list
    logger.deb('Adding to download list...')
    downloadList.add(url, options)
    if path.extname(file_save) == '.zip'
      # body...
      # Extract
      logger.deb("Extracting using npm module #{"\'unzip\'".green}...")
      fs.createReadStream file_save
        .pipe unzip.Extract( path: "#{retis_plugin_dir}/.tmp/extract" )
        .on('close', ->
          unpackPlugin(file_save)
        )
        .on('error', (err) ->
          throw err
        )
    else if path.extname(file_save) == '.gz' || path.extname(file_save) == '.tar.gz'
      # body...
      logger.deb("Extracting using npm module #{"\'tar.gz\'".green}...")
      targz().extract file_save, "#{retis_plugin_dir}/.tmp/extract", (err) ->
        throw err if err
        unpackPlugin(file_save)
  )
  # unzip
  return
