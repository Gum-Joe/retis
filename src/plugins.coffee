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
unzip = require 'unzip2'
zlib = require 'zlib'
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
  # Download
  logger.info("Downloading #{url}...")
  @download_options =
    hostname: urlm.parse(url).hostname
    path: urlm.parse(url).path
    method: 'GET'
  file_save = "#{retis_plugin_dir}/.tmp/"+url.split('/')[url.split('/').length - 1]
  file_stream = fs.createWriteStream(file_save)
  # Make req
  @req = https.request(@download_options, (res) ->
    logger.deb 'statusCode: '+res.statusCode
    logger.deb 'headers: \n'+JSON.stringify(res.headers, null, '\t')
    res.on('end', () ->
      logger.info("Downloaded #{url}.")
      #path: "#{retis_plugin_dir}/.tmp/test"
      console.log zlib.unzipSync(fs.readFileSync(file_save))
    )
    res.on 'data', (d) ->
      file_stream.write d
      return
    )

  @req.end()
  @req.on 'error', (e) ->
    console.error e
    return
  # unzip
  return
