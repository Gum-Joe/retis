
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
  var _logger, err, fail, return_val;
  this.logger = new Logger('retis', options);
  fail = new Failer(this.logger);
  this.file = '.retis.yml';
  if (fs.existsSync('retis.json')) {
    this.file = 'retis.json';
  }
  if (fs.existsSync('retis.cson')) {
    this.file = 'retis.cson';
  }
  if (fs.existsSync('psf.json')) {
    this.file = 'psf.json';
  }
  if (fs.existsSync('psf.cson')) {
    this.file = 'psf.cson';
  }
  if (typeof options.file !== 'undefined') {
    this.logger.deb('A file was already specified.');
    this.logger.deb("File: " + ("\'" + options.file + "\'").green);
    this.file = options.file;
  }
  this.logger.deb("Parseing build specification file " + this.file + "...");
  this.logger.deb('Checking if file exists...');
  _logger = this.logger;
  fs.stat(this.file, function(err, stat) {
    if (err) {
      _logger.info('Error parsing build specification file!');
      throw err;
    }
    if (stat.isDirectory()) {
      _logger.info('File specified was a directory and not a file!');
      throw new Error('File was a directory and not a file!');
    }
  });
  this.logger.deb('Found file. Parsing');
  this.file_suffix = path.extname(this.file);
  this.logger.deb("File Extension: " + ("\'" + this.file_suffix + "\'").green);
  if (this.file_suffix === ".yml") {
    this.logger.deb('Parsing using npm module \'yamljs\'...');
    return YAML.load(path.join(process.cwd(), this.file));
  } else if (this.file_suffix === ".json") {
    this.logger.deb('Parsing using nodejs\'s json parser...');
    return require(path.join(process.cwd(), this.file));
  } else if (this.file_suffix === ".cson") {
    this.logger.deb('Parsing using npm module \'cson\'...');
    return_val = CSON.parse(fs.readFileSync(path.join(process.cwd(), this.file)));
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
