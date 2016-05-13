# File to unpack plugins
###
# Module dependencies
###
CSON = require 'cson'
path = require 'path'
fs = require 'fs'
os = require 'os'
unzip = require 'unzip'
targz = require 'tar.gz'
rimraf = require 'rimraf'
{Logger} = require '../logger'
{get} = require('../downloader')
###
# Vars
###
unpack = module.exports = {}
retis_plugin_dir = '.retis/plugins'
retis_plugin_dir = path.join(os.homedir(), retis_plugin_dir)
# File to add loaded to
load_file = path.join(process.cwd(), '.retis/config.cson')

###
# Unpack function
# @param file {String} File to extract
# @param options {Object}
# @param logger {Logger} Logger
# @param callback {Function} callback
###
unpack.unpack = (file, options, logger, callback) ->
  # Make logger
  callback = logger if typeof logger == 'function'
  logger = new Logger('retis', options) if typeof logger == 'undefined' && typeof logger != 'function'
  logger.deb('Downloading archive...')
  # File
  if path.extname(file) != '.cson'
    if callback
      # body...
      callback new Error "File #{file} is not a cson file!"
      return
    else
      throw new Error("File #{file} is not a cson file!")

  # Continue
  # Get data
  data = CSON.parse fs.readFileSync(file, 'utf8')
  # Check errors
  if data instanceof Error
    throw data
  logger.deb "Parsed data from #{file}."
  if !(data.hasOwnProperty 'url')
    # body...
    logger.deb "URL not specified in plugin specification!"
    err = new Error "No url was specified in the plugin specification file #{file}"
    if callback
      callback err
    else
      throw err
  data.extract_dir = data.name if data.hasOwnProperty('extract_dir') == false
  file_save = "#{retis_plugin_dir}/.tmp/download/#{data.extract_dir}#{path.extname data.url}"
  logger.deb "Downloading archive from #{data.url}..."
  get(data.url, file_save, options, (err) ->
    logger.deb "Saved to #{file_save}."
    return callback(err) if err
    throw err if err && typeof callback == 'undefined'
    logger.deb "Feched file"
    logger.deb "Extracting #{file_save}..."
    if path.extname(file_save) == '.zip'
      # body...
      # Extract
      logger.deb("Extracting using npm module #{"\'unzip\'".green}...")
      fs.createReadStream file_save
        .pipe unzip.Extract( path: "#{retis_plugin_dir}/.tmp/extract" )
        .on('close', ->
          logger.deb "Extracted '#{file_save}'"
          _finishExtract(data, logger, (err) ->
            if err
              if typeof callback != 'undefined'
                callback err
              else
                throw err
            else
              _cleanUp({ config: data, file: file_save, config_file: file, logger: logger }, callback)
          )
          return
        )
        .on('error', (err) ->
          if typeof callback != 'undefined'
            # body...
            callback err
          else
            throw err
        )
    else if path.extname(file_save) == '.gz' || path.extname(file_save) == '.tar.gz'
      # body...
      logger.deb("Extracting using npm module #{"\'tar.gz\'".green}...")
      targz().extract file_save, "#{retis_plugin_dir}/.tmp/extract", (err) ->
        if err
          if typeof callback != 'undefined'
            # body...
            callback err
          else
            throw err
        logger.deb "Extracted '#{file_save}'"
        _finishExtract(data, logger, (err) ->
          if err
            if typeof callback != 'undefined'
              callback err
            else
              throw err
          else
            _cleanUp({ config: data, file: file_save, config_file: file, logger: logger }, callback)
        )
        return
    else
      err = new Error "Plugin archive format #{path.extname file_save}, from #{data.url}, is not supported"
      if typeof callback != 'undefined'
        # body...
        callback err
      else
        throw err
  )
  return

###
# Clean up
# @param options {Object} Options
# @param callback {Function} Callback
###
_cleanUp = (options, callback) ->
  logger = options.logger
  config = options.config
  logger.deb "Cleaning up..."
  logger.deb "Moving config file #{options.config_file.cyan.bold} to #{"#{retis_plugin_dir}/#{config.name}.psf.cson...".green.bold}"
  fs.renameSync options.config_file, "#{retis_plugin_dir}/#{config.name}.psf.cson"
  logger.deb "Removing tmp archive file..."
  fs.unlinkSync options.file
  logger.deb "Removed tmp files."
  callback null
  return

###
# Add plugin to load list
# @param name {String} Name of package
# @param logger {Logger} Logger
# @param callback {Function} Callback
###
_addToLoadList = (name, logger, callback) ->
  logger.deb("Adding package #{name.green} to load list (#{load_file.cyan})...")
  logger.deb "Parsing old load list..."
  load = CSON.parse fs.readFileSync(load_file, 'utf8')
  # Check errors
  if load instanceof Error
    if typeof callback != 'undefined'
      # body...
      callback load
    else
      throw load
  if not load.hasOwnProperty 'packages'
    load.packages = []
  # Add
  load.packages.push name
  logger.deb "Re-writting to file..."
  CSON.createCSONString load, {}, (err, result) ->
    # Error?
    if err
      if typeof callback != 'undefined'
        # body...
        callback err
        return
      else
        throw err
    # Write out
    fs.writeFileSync(load_file, result, 'utf8')
    # Callback
    callback null
  return
###
# Finish extraction
# @param config {Object} Plugin config
# @param logger {Logger} Logger
# @param callback {Function} Callback
# @private
###
_finishExtract = (config, logger, callback) ->
  logger.deb("Installing plugin #{config.name}...")
  if config.hasOwnProperty('extract_dir') == false
    # body...
    logger.deb("No extracted directory specified for plugin #{config.name}!")
    err = new Error "No extracted directory specified for plugin #{config.name}!"
    if typeof callback != 'undefined'
      # body...
      callback err
    else
      throw err
  # Rename to plugin name
  # Check exist
  if fs.existsSync "#{retis_plugin_dir}/#{config.name}"
    logger.deb "Deleting previous package..."
    rimraf.sync "#{retis_plugin_dir}/#{config.name}", rmdir: fs.rmdir
    # body...
  logger.deb "Finshing install of plugin #{config.name}..."
  fs.rename "#{retis_plugin_dir}/.tmp/extract/#{config.extract_dir}", "#{retis_plugin_dir}/#{config.name}", (err) ->
    if err
      if typeof callback != 'undefined'
        # body...
        callback err
      else
        throw err
    _addToLoadList(config.name, logger, callback)
