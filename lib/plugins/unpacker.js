
/*
 * Module dependencies
 */
var CSON, Logger, _addToLoadList, _cleanUp, _finishExtract, fs, get, os, path, retis_plugin_dir, rimraf, targz, unpack, unzip;

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
  if (data instanceof Error) {
    throw data;
  }
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
  get(data.url, file_save, options, function(err) {
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
        _finishExtract(data, logger, function(err) {
          if (err) {
            if (typeof callback !== 'undefined') {
              return callback(err);
            } else {
              throw err;
            }
          } else {
            return _cleanUp({
              config: data,
              file: file_save,
              config_file: file,
              logger: logger
            }, callback);
          }
        });
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
        _finishExtract(data, logger, function(err) {
          if (err) {
            if (typeof callback !== 'undefined') {
              return callback(err);
            } else {
              throw err;
            }
          } else {
            return _cleanUp({
              config: data,
              file: file_save,
              config_file: file,
              logger: logger
            }, callback);
          }
        });
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
 * Clean up
 * @param options {Object} Options
 * @param callback {Function} Callback
 */

_cleanUp = function(options, callback) {
  var config, logger;
  logger = options.logger;
  config = options.config;
  logger.deb("Cleaning up...");
  logger.deb("Moving config file " + options.config_file.cyan.bold + " to " + (retis_plugin_dir + "/" + config.name + ".psf.cson...").green.bold);
  fs.renameSync(options.config_file, retis_plugin_dir + "/" + config.name + ".psf.cson");
  logger.deb("Removing tmp archive file...");
  fs.unlinkSync(options.file);
  logger.deb("Removed tmp files.");
  callback(null);
};


/*
 * Add plugin to load list
 * @param name {String} Name of package
 * @param logger {Logger} Logger
 * @param callback {Function} Callback
 */

_addToLoadList = function(name, logger, callback) {

  /*
   * Vars
   * These have to be declared on run
   * of function
   * This so process.cwd() is correct.
   */
  var load, load_file;
  load_file = path.join(process.cwd(), '.retis/config.cson');
  logger.deb("Adding package " + name.green + " to load list (" + load_file.cyan + ")...");
  logger.deb("Parsing old load list...");
  load = CSON.parse(fs.readFileSync(load_file, 'utf8'));
  if (load instanceof Error) {
    if (typeof callback !== 'undefined') {
      callback(load);
    } else {
      throw load;
    }
  }
  if (!load.hasOwnProperty('packages')) {
    load.packages = [];
  }
  if (!load.packages.includes(name)) {
    load.packages.push(name);
  }
  logger.deb("Re-writting to file...");
  CSON.createCSONString(load, {}, function(err, result) {
    if (err) {
      if (typeof callback !== 'undefined') {
        callback(err);
        return;
      } else {
        throw err;
      }
    }
    fs.writeFileSync(load_file, result, 'utf8');
    return callback(null);
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
    return _addToLoadList(config.name, logger, callback);
  });
};
