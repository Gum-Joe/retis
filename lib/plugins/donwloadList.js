
/*
 * Module dependencies
 */
var CSON, Logger, fs, list, mkdirp, os, path, upath,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

CSON = require('cson');

fs = require('fs');

mkdirp = require('mkdirp');

Logger = require('../logger').Logger;

path = require('path');

os = require('os');

upath = require('upath');


/*
 * Vars
 */

list = module.exports = {};


/*
 * Add method
 * @param url {String} url to add
 * @param options {Object} logger options
 */

list.add = function(url, options) {
  var current_file, list_file, logger;
  logger = new Logger('retis', options);
  list_file = path.join(os.homedir(), '.retis/plugins/.config/downloadlist.cson');
  logger.deb("Adding " + url + " to list...");
  if (fs.existsSync(list_file) === false) {
    logger.deb("Creating download list file in " + ("\'" + list_file + "\'").green + "...");
    fs.writeFileSync(list_file, 'urls: []', 'utf8');
    logger.deb("Created download list file in " + ("\'" + list_file + "\'").green + ".");
  }
  current_file = CSON.parse(fs.readFileSync(list_file));
  current_file.urls.push(url);
  CSON.createCSONString(current_file, {}, function(err, result) {
    if (err) {
      throw err;
    }
    return fs.writeFileSync(list_file, result, 'utf8');
  });
};


/*
 * Check method
 * @param url {String} url to check
 * @param options {Object} Options
 */

list.check = function(url, options) {
  var current_file, list_file, logger;
  logger = new Logger('retis', options);
  list_file = path.join(os.homedir(), '.retis/plugins/.config/downloadlist.cson');
  if (fs.existsSync(list_file) === false) {
    logger.deb("Creating download list file in " + ("\'" + list_file + "\'").green + "...");
    fs.writeFileSync(list_file, 'urls: []', 'utf8');
    logger.deb("Created download list file in " + ("\'" + list_file + "\'").green + ".");
  }
  current_file = CSON.parse(fs.readFileSync(list_file));
  if (indexOf.call(current_file.urls, url) >= 0) {
    return true;
  } else {
    return false;
  }
};
