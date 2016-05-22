var ENV, Logger, chalk, debug_module;

debug_module = require('debug');

chalk = require('chalk');

chalk = new chalk.constructor({
  enabled: true
});

require('colours');

ENV = process.env;


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
    this.starttime = Date.now();
    if (typeof this.options.silent !== 'undefined' && this.options.silent) {
      console.log = function() {};
    }
  }


  /*
   * Info method
   *
   * @colour green
   * @param txt {String} Text to output
   */

  Logger.prototype.info = function(txt) {
    var infostring, time;
    infostring = chalk.green("INFO");
    if (typeof ENV['DEBUG'] !== 'undefined' && ~ENV['DEBUG'].indexOf(this.prefix)) {
      return this.debug(("" + infostring).green + " " + txt);
    } else {
      time = (new Date().getHours()) + ":" + (new Date().getMinutes()) + ":" + (new Date().getSeconds());
      if (!this.options.hasOwnProperty('silent') || !this.options.silent) {
        return console.log(("[ " + (chalk.grey(time)) + " " + infostring + " ]") + " " + txt);
      }
    }
  };


  /*
   * Running method
   *
   * @colour magenta
   * @param txt {String} Text to output
   */

  Logger.prototype.running = function(txt) {
    var runningstring, time;
    runningstring = chalk.blue.bold("EXEC");
    if (typeof ENV['DEBUG'] !== 'undefined' && ~ENV['DEBUG'].indexOf(this.prefix)) {
      return this.debug(("" + runningstring).blue.bold + " " + txt);
    } else {
      time = (new Date().getHours()) + ":" + (new Date().getMinutes()) + ":" + (new Date().getSeconds());
      if (!this.options.hasOwnProperty('silent') || !this.options.silent) {
        return console.log(("[ " + (chalk.grey(time)) + " " + runningstring + " ]") + " " + txt);
      }
    }
  };


  /*
   * Stdout method
   *
   * @colour magenta
   * @param txt {String} Text to output
   */

  Logger.prototype.stdout = function(txt) {
    var runningstring, time;
    runningstring = chalk.magenta.bold("SOUT");
    if (typeof ENV['DEBUG'] !== 'undefined' && ~ENV['DEBUG'].indexOf(this.prefix)) {
      return this.debug(("" + runningstring).magenta.bold + " " + txt);
    } else {
      time = (new Date().getHours()) + ":" + (new Date().getMinutes()) + ":" + (new Date().getSeconds());
      if (!this.options.hasOwnProperty('silent') || !this.options.silent) {
        return console.log(("[ " + (chalk.grey(time)) + " " + runningstring + " ]") + " " + txt);
      }
    }
  };


  /*
   * Stderr method
   *
   * @colour red
   * @param txt {String} Text to output
   */

  Logger.prototype.stderr = function(txt) {
    var runningstring, time;
    runningstring = chalk.red.bold("SERR");
    if (typeof ENV['DEBUG'] !== 'undefined' && ~ENV['DEBUG'].indexOf(this.prefix)) {
      return this.debug(("" + runningstring).red.bold + " " + txt);
    } else {
      time = (new Date().getHours()) + ":" + (new Date().getMinutes()) + ":" + (new Date().getSeconds());
      if (!this.options.hasOwnProperty('silent') || !this.options.silent) {
        return console.error(("[ " + (chalk.grey(time)) + " " + runningstring + " ]") + " " + txt);
      }
    }
  };


  /*
   * Error method
   *
   * @colour red
   * @param txt {String} Text to output
   */

  Logger.prototype.err = function(txt) {
    var runningstring, time;
    runningstring = chalk.bgRed("ERROR");
    if (typeof ENV['DEBUG'] !== 'undefined' && ~ENV['DEBUG'].indexOf(this.prefix)) {
      return this.debug(("" + runningstring).red.bold + " " + txt);
    } else {
      time = (new Date().getHours()) + ":" + (new Date().getMinutes()) + ":" + (new Date().getSeconds());
      if (!this.options.hasOwnProperty('silent') || !this.options.silent) {
        return console.error(("[ " + (chalk.grey(time)) + " " + runningstring + " ]") + " " + txt);
      }
    }
  };


  /*
   * Warn method
   *
   * @colour yellow
   * @param txt {String} Text to output
   */

  Logger.prototype.warn = function(txt) {
    var time, warnstring;
    warnstring = chalk.yellow("WARN");
    if (typeof ENV['DEBUG'] !== 'undefined' && ~ENV['DEBUG'].indexOf(this.prefix)) {
      return this.debug(("" + warnstring).yellow + " " + txt);
    } else {
      time = (new Date().getHours()) + ":" + (new Date().getMinutes()) + ":" + (new Date().getSeconds());
      if (!this.options.hasOwnProperty('silent') || !this.options.silent) {
        return console.warn(("[ " + (chalk.grey(time)) + " " + warnstring + " ]") + " " + txt);
      }
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
      return this.debug(debugstring.cyan + " " + txt);
    } else if (this.options.hasOwnProperty('debug') && typeof this.options.debug !== 'undefined') {
      if (!this.options.hasOwnProperty('silent') || !this.options.silent) {
        return console.log(("[" + this.prefix + " " + debugstring + "]").cyan + " " + txt);
      }
    }
  };

  return Logger;

})();

module.exports = {
  Logger: Logger
};
