
/*
 * Module dependencies
 */
var Logger, downloadList, fs, get, https, log, mkdirp, os, path, plugins, request, retis_plugin_dir, targz, unzip, urlm, zlib;

Logger = require('./logger').Logger;

fs = require('fs');

path = require('path');

os = require('os');

mkdirp = require('mkdirp');

request = require('request');

https = require('follow-redirects').https;

fs = require('fs');

urlm = require('url');

unzip = require('unzip');

zlib = require('zlib');

targz = require('tar.gz');

log = require('single-line-log').stdout;

get = require('./downloader').get;

downloadList = require('./plugins/donwloadList');


/*
 * Vars
 */

plugins = module.exports = {};

retis_plugin_dir = '.retis/plugins';

retis_plugin_dir = path.join(os.homedir(), retis_plugin_dir);


/*
 * Download method
 * @param url {String} URL to download
 * @param options {Object} Options
 */

plugins.fetchPlugin = function(url, options) {
  var file_save, logger;
  logger = new Logger('retis', options);
  logger.deb('Downloading plugin...');
  logger.deb("Creating dir " + retis_plugin_dir + "...");
  if (fs.existsSync(retis_plugin_dir) === false) {
    mkdirp(retis_plugin_dir, function(err) {
      if (err) {
        throw err;
      }
    });
  }
  logger.deb("Created dir " + retis_plugin_dir + ".");
  logger.deb("Creating dir " + retis_plugin_dir + "/.tmp...");
  if (fs.existsSync(retis_plugin_dir + "/.tmp") === false) {
    mkdirp(retis_plugin_dir + "/.tmp", function(err) {
      if (err) {
        throw err;
      }
    });
  }
  logger.deb("Created dir " + retis_plugin_dir + "/.tmp.");
  logger.deb("Creating dir " + retis_plugin_dir + "/.tmp/download...");
  if (fs.existsSync(retis_plugin_dir + "/.tmp/download") === false) {
    mkdirp(retis_plugin_dir + "/.tmp/download", function(err) {
      if (err) {
        throw err;
      }
    });
  }
  logger.deb("Created dir " + retis_plugin_dir + "/.tmp/download.");
  logger.deb("Creating dir " + retis_plugin_dir + "/.tmp/extract...");
  if (fs.existsSync(retis_plugin_dir + "/.tmp/extract") === false) {
    mkdirp(retis_plugin_dir + "/.tmp/extract", function(err) {
      if (err) {
        throw err;
      }
    });
  }
  logger.deb("Created dir " + retis_plugin_dir + "/.tmp/extract.");
  logger.deb("Creating dir " + retis_plugin_dir + "/.config/...");
  if (fs.existsSync(retis_plugin_dir + "/.config/") === false) {
    mkdirp(retis_plugin_dir + "/.config/", function(err) {
      if (err) {
        throw err;
      }
    });
  }
  logger.deb("Created dir " + retis_plugin_dir + "/.config/.");
  if (downloadList.check(url, options) && typeof options.force === 'undefined') {
    logger.deb("Skipping plugin from url " + url + "...");
    return;
  }
  this.download_options = {
    hostname: urlm.parse(url).hostname,
    path: urlm.parse(url).path,
    method: 'GET'
  };
  file_save = (retis_plugin_dir + "/.tmp/download/") + url.split('/')[url.split('/').length - 1];
  get(url, file_save, this.download_options, function(err) {
    if (err) {
      throw err;
    }
    logger.deb('Adding to download list...');
    downloadList.add(url, options);
    if (path.extname(file_save) === '.zip') {
      logger.deb("Extracting using npm module " + "\'unzip\'".green + "...");
      return fs.createReadStream(file_save).pipe(unzip.Extract({
        path: retis_plugin_dir + "/.tmp/extract"
      })).on('close', function() {
        return unpackPlugin(file_save);
      }).on('error', function(err) {
        throw err;
      });
    } else if (path.extname(file_save) === '.gz' || path.extname(file_save) === '.tar.gz') {
      logger.deb("Extracting using npm module " + "\'tar.gz\'".green + "...");
      return targz().extract(file_save, retis_plugin_dir + "/.tmp/extract", function(err) {
        if (err) {
          throw err;
        }
        return unpackPlugin(file_save);
      });
    }
  });
};
