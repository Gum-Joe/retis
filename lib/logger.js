var ENV, Logger, app, debug_module, that;

debug_module = require('debug');

require('colours');

app = module.exports = {};

ENV = process.env;

that = {};


/*
 * Logger Class
 *
 * @class Logger
 * @param prefix {String} prefix
 */

Logger = (function() {
  function Logger(prefix, options) {
    this.prefix = prefix;
    this.debug = debug_module(prefix);
    this.options = options;
  }


  /*
   * Info method
   *
   * @colour green
   * @param txt {String} Text to output
   */

  Logger.prototype.info = function(txt) {
    var infostring;
    infostring = "INFO";
    if (typeof ENV['DEBUG'] !== 'undefined' && ~ENV['DEBUG'].indexOf(this.prefix)) {
      return this.debug(("" + infostring).green + " " + txt);
    } else {
      return console.log(("[" + this.prefix + " " + infostring + "]").green + " " + txt);
    }
  };


  /*
   * Running method
   *
   * @colour magenta
   * @param txt {String} Text to output
   */

  Logger.prototype.running = function(txt) {
    var runningstring;
    runningstring = "RUN";
    if (typeof ENV['DEBUG'] !== 'undefined' && ~ENV['DEBUG'].indexOf(this.prefix)) {
      return this.debug(("" + runningstring).magenta + " " + txt);
    } else {
      return console.log(("[" + this.prefix + " " + runningstring + "]").magenta + " " + txt);
    }
  };


  /*
   * Stdout method
   *
   * @colour magenta
   * @param txt {String} Text to output
   */

  Logger.prototype.stdout = function(txt) {
    var runningstring;
    runningstring = "STDOUT";
    if (typeof ENV['DEBUG'] !== 'undefined' && ~ENV['DEBUG'].indexOf(this.prefix)) {
      return this.debug(("" + runningstring).magenta + " " + txt);
    } else {
      return console.log(("[" + this.prefix + " " + runningstring + "]").magenta + " " + txt);
    }
  };


  /*
   * Stderr method
   *
   * @colour magenta
   * @param txt {String} Text to output
   */

  Logger.prototype.stderr = function(txt) {
    var runningstring;
    runningstring = "STDERR";
    if (typeof ENV['DEBUG'] !== 'undefined' && ~ENV['DEBUG'].indexOf(this.prefix)) {
      return this.debug(("" + runningstring).red + " " + txt);
    } else {
      return console.log(("[" + this.prefix + " " + runningstring + "]").red + " " + txt);
    }
  };


  /*
   * Warn method
   *
   * @colour yellow
   * @param txt {String} Text to output
   */

  Logger.prototype.warn = function(txt) {
    var warnstring;
    warnstring = "WARN";
    if (typeof ENV['DEBUG'] !== 'undefined' && ~ENV['DEBUG'].indexOf(this.prefix)) {
      return this.debug(("" + warnstring).yellow + " " + txt);
    } else {
      return console.warn(("[" + this.prefix + " " + warnstring + "]").yellow + " " + txt);
    }
  };


  /*
   * Debug method
   *
   * @colour cyan
   * @param txt {String} Text to output
   */

  Logger.prototype.deb = function(txt) {
    var debugstring;
    debugstring = "DEBUG";
    if (typeof ENV['DEBUG'] !== 'undefined' && ~ENV['DEBUG'].indexOf(this.prefix)) {
      return this.debug(debugstring + " " + txt);
    } else if (this.options.hasOwnProperty('debug') && typeof this.options.debug !== 'undefined') {
      return console.log(("[" + this.prefix + " " + debugstring + "]").cyan + " " + txt);
    }
  };

  return Logger;

})();

module.exports = {
  Logger: Logger
};
