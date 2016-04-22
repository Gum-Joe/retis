
/*
 * Module dependencies
 */
var CSON, Logger, _finishExtract, fs, get, os, path, retis_plugin_dir, rimraf, targz, unpack, unzip;

CSON = require('cson');

path = require('path');

fs = require('fs');

os = require('os');

unzip = require('unzip');

targz = require('tar.gz');

rimraf = require('rimraf');

Logger = require('../logger').Logger;

get = require('../downloader').get;


/*
 * Vars
 */

unpack = module.exports = {};

retis_plugin_dir = '.retis/plugins';

retis_plugin_dir = path.join(os.homedir(), retis_plugin_dir);


/*
 * Unpack function
 * @param file {String} File to extract
 * @param options {Object}
 * @param logger {Logger} Logger
 * @param callback {Function} callback
 */

unpack.unpack = function(file, options, logger, callback) {
  var data, err, file_save;
  file = './plugintest.cson';
  if (typeof logger === 'function') {
    callback = logger;
  }
  if (typeof logger === 'undefined' && typeof logger !== 'function') {
    logger = new Logger('retis', options);
  }
  logger.deb('Downloading archive...');
  if (path.extname(file) !== '.cson') {
    if (callback) {
      callback(new Error("File " + file + " is not a cson file!"));
      return;
    } else {
      throw new Error("File " + file + " is not a cson file!");
    }
  }
  data = CSON.parse(fs.readFileSync(file, 'utf8'));
  logger.deb("Parsed data from " + file + ".");
  if (!(data.hasOwnProperty('url'))) {
    logger.deb("URL not specified in plugin specification!");
    err = new Error("No url was specified in the plugin specification file " + file);
    if (callback) {
      callback(err);
    } else {
      throw err;
    }
  }
  if (data.hasOwnProperty('extract_dir') === false) {
    data.extract_dir = data.name;
  }
  file_save = retis_plugin_dir + "/.tmp/download/" + data.extract_dir + (path.extname(data.url));
  logger.deb("Downloading archive from " + data.url + "...");
  get(data.url, file_save, this.download_options, function(err) {
    logger.deb("Saved to " + file_save + ".");
    if (err) {
      return callback(err);
    }
    if (err && typeof callback === 'undefined') {
      throw err;
    }
    logger.deb("Feched file");
    logger.deb("Extracting " + file_save + "...");
    if (path.extname(file_save) === '.zip') {
      logger.deb("Extracting using npm module " + "\'unzip\'".green + "...");
      return fs.createReadStream(file_save).pipe(unzip.Extract({
        path: retis_plugin_dir + "/.tmp/extract"
      })).on('close', function() {
        logger.deb("Extracted '" + file_save + "'");
        _finishExtract(data, logger, callback);
      }).on('error', function(err) {
        if (typeof callback !== 'undefined') {
          return callback(err);
        } else {
          throw err;
        }
      });
    } else if (path.extname(file_save) === '.gz' || path.extname(file_save) === '.tar.gz') {
      logger.deb("Extracting using npm module " + "\'tar.gz\'".green + "...");
      return targz().extract(file_save, retis_plugin_dir + "/.tmp/extract", function(err) {
        if (err) {
          if (typeof callback !== 'undefined') {
            callback(err);
          } else {
            throw err;
          }
        }
        logger.deb("Extracted '" + file_save + "'");
        _finishExtract(data, logger, callback);
      });
    } else {
      err = new Error("Plugin archive format " + (path.extname(file_save)) + ", from " + data.url + ", is not supported");
      if (typeof callback !== 'undefined') {
        return callback(err);
      } else {
        throw err;
      }
    }
  });
};


/*
 * Finish extraction
 * @param config {Object} Plugin config
 * @param logger {Logger} Logger
 * @param callback {Function} Callback
 * @private
 */

_finishExtract = function(config, logger, callback) {
  var err;
  logger.deb("Installing plugin " + config.name + "...");
  if (config.hasOwnProperty('extract_dir') === false) {
    logger.deb("No extracted directory specified for plugin " + config.name + "!");
    err = new Error("No extracted directory specified for plugin " + config.name + "!");
    if (typeof callback !== 'undefined') {
      callback(err);
    } else {
      throw err;
    }
  }
  if (fs.existsSync(retis_plugin_dir + "/" + config.name)) {
    logger.deb("Deleting previous package...");
    rimraf.sync(retis_plugin_dir + "/" + config.name, {
      rmdir: fs.rmdir
    });
  }
  logger.deb("Finshing install of plugin " + config.name + "...");
  return fs.rename(retis_plugin_dir + "/.tmp/extract/" + config.extract_dir, retis_plugin_dir + "/" + config.name, function(err) {
    if (err) {
      if (typeof callback !== 'undefined') {
        callback(err);
      } else {
        throw err;
      }
    }
    return callback(null);
  });
};
