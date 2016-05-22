
/*
 * Module dependencies
 */
var Logger, chalk, downloader, fs, progress, request;

request = require('request');

progress = require('request-progress');

Logger = require('./logger').Logger;

chalk = require('chalk');

chalk = new chalk.constructor({
  enabled: true
});

fs = require('fs');

require('colours');

downloader = module.exports = {};


/*
 * Downloader
 * @param url {String} url to GET
 * @param save {String} Save file
 * @param options {Object} Options
 * @param callback {Function} Callback
 */

downloader.get = function(url, save, options, callback) {
  var file_stream, info, infostring, log, logger, time;
  log = require('single-line-log').stdout;
  logger = new Logger('retis', options);
  if (options.hasOwnProperty('silent') && options.silent) {
    log = function() {};
  }
  file_stream = fs.createWriteStream(save);
  time = chalk.grey((new Date().getHours()) + ":" + (new Date().getMinutes()) + ":" + (new Date().getSeconds()));
  infostring = chalk.green("INFO");
  info = "[ " + time + " " + infostring + " ]";
  log(info + " Downloading " + url + "...0% at 0 kb/sec...\n");
  progress(request(url)).on('progress', function(state) {
    var percent;
    percent = (Math.floor(state.percentage * 100)) + "% [" + (Math.round(state.size.transferred / 1024)) + " kb of " + (Math.round(state.size.total / 1024)) + " kb]";
    return log(info + " Downloading " + url + "..." + percent + " at " + (Math.round(state.speed / 1024)) + " kb/sec...\n");
  }).on('data', function(d) {
    file_stream.write(d);
  }).on('error', function(e) {
    callback(e);
  }).on('end', function() {
    log(info + " Downloading " + url + "...100%\n");
    logger.info("Downloaded " + url + ".\n");
    callback();
  });
};
