
/*
 * Module dependencies
 */
var CSON, Failer, Logger, YAML, fs, parser, path;

fs = require('fs');

path = require('path');

YAML = require('yamljs');

CSON = require('cson');

Logger = require('./logger').Logger;

Failer = require('./fail');

require('colours');

parser = module.exports = {};


/*
 * Parse method
 *
 * @param options {Object} Options
 */

parser.parseConfig = function(options, callback) {
  var _logger, err, fail, file, file_suffix, return_val, stat;
  this.logger = new Logger('retis', options);
  fail = new Failer(this.logger);
  file = '.retis.yml';
  if (fs.existsSync('retis.json')) {
    file = 'retis.json';
  }
  if (fs.existsSync('retis.cson')) {
    file = 'retis.cson';
  }
  if (fs.existsSync('psf.json')) {
    file = 'psf.json';
  }
  if (fs.existsSync('psf.cson')) {
    file = 'psf.cson';
  }
  if (typeof options.file !== 'undefined') {
    this.logger.deb('A file was already specified.');
    this.logger.deb("File: " + ("\'" + options.file + "\'").green);
    file = options.file;
  }
  this.logger.deb("Parseing build specification file " + file + "...");
  this.logger.deb('Checking if file exists...');
  _logger = this.logger;
  stat = fs.statSync(file);
  if (stat.isDirectory()) {
    fail.fail(new Error('File was a directory and not a file!'));
  }
  this.logger.deb('Found file. Parsing');
  file_suffix = path.extname(file);
  this.logger.deb("File Extension: " + ("\'" + file_suffix + "\'").green);
  if (file_suffix === ".yml") {
    this.logger.deb('Parsing using npm module \'yamljs\'...');
    return YAML.load(path.join(process.cwd(), file));
  } else if (file_suffix === ".json") {
    this.logger.deb('Parsing using nodejs\'s json parser...');
    return require(path.join(process.cwd(), file));
  } else if (file_suffix === ".cson") {
    this.logger.deb('Parsing using npm module \'cson\'...');
    return_val = CSON.parse(fs.readFileSync(path.join(process.cwd(), file)));
    if (return_val instanceof Error) {
      this.logger.deb("Error parsing project specification!");
      err = new Error("Error parsing project specification: " + return_val);
      err.stack = return_val.stack;
      fail.fail(err);
    }
    return return_val;
  } else {
    if (typeof callback !== 'undefined') {
      return new TypeError('Type of build specification file was not reconised.');
    } else {
      fail.fail(new TypeError('Type of build specification file was not reconised.'));
    }
  }
};
