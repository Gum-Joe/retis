
/*
 * Module dependencies
 */
var Failer, callerId, fail, tab, upath;

require('colours');

callerId = require('caller-id');

upath = require('upath');


/*
 * Vars
 */

tab = " ";


/*
 * Fail build
 * @param err {Error} Error to fail with
 */

fail = function(err) {
  var e, error_array, filePath, filePath2, i, len, memory, mems;
  if (process.env.NODE_ENV === 'test') {
    throw err;
    return;
  }
  memory = process.memoryUsage();
  mems = (Math.round(memory.heapUsed / 1024 / 1024)) + " / " + (Math.round(memory.heapTotal / 1024 / 1024)) + " MB ";
  filePath = upath.normalize(callerId.getData().filePath);
  error_array = err.stack.split('\n');
  filePath2 = upath.normalize(error_array[1]);
  this.logger.err('-----------------------------------------------------------------');
  this.logger.err(tab + "BUILD FAILURE!");
  this.logger.err('-----------------------------------------------------------------');
  this.logger.err(tab + "Finished at: " + (Date()));
  this.logger.err(tab + "Memory: " + mems);
  this.logger.err(tab + "Build duration: " + ((Date.now() - this.logger.starttime) / 100) + " s");
  this.logger.err('-----------------------------------------------------------------');
  this.logger.err("");
  this.logger.err("" + error_array[0]);
  this.logger.err("");
  if (filePath2.includes('node_modules/retis') || filePath2.includes('node_modules/retis-ci') || (filePath2.includes('retis-ci') && process.env.NODE_ENV !== 'production') || (filePath2.includes('retisci') && process.env.NODE_ENV !== 'production')) {
    if (!(filePath2.includes('node_modules/retis/node_modules') || filePath2.includes('node_modules/retis-ci/node_modules') || (filePath2.includes('retis-ci/node_modules') && process.env.NODE_ENV !== 'production') || (filePath2.includes('retisci/node_modules') && process.env.NODE_ENV !== 'production'))) {
      this.logger.err("This is a problem with retis. Please file an issue at https://github.com/jakhu/retis-ci.");
      this.logger.err(tab + "<https://github.com/Gum-Joe/retis>");
      this.logger.err("");
    } else {
      this.logger.err("This is a problem with one of retis's dependencies. Please file an issue at https://github.com/jakhu/retis-ci.");
      this.logger.err(tab + "<https://github.com/Gum-Joe/retis>");
      this.logger.err("");
    }
  } else {
    this.logger.err("This is not a problem with retis, but a problem with a 3rd party package or tool.");
  }
  if (this.options.hasOwnProperty('debug') && this.options.debug) {
    this.logger.err(tab + "File: " + filePath + ",");
    this.logger.err(tab + "Function: " + (callerId.getData().functionName) + "()");
  }
  this.logger.err("");
  if (this.options.hasOwnProperty('onError')) {
    return this.options.onError(err);
  } else {
    if ((this.options.hasOwnProperty('trace') && this.options.trace) || (this.options.hasOwnProperty('debug') && this.options.debug) || (process.env.NODE_ENV === 'dev' || process.env.NODE_ENV === 'development')) {
      this.logger.err("Full error message:");
      this.logger.err("");
      for (i = 0, len = error_array.length; i < len; i++) {
        e = error_array[i];
        this.logger.err(e);
      }
    } else {
      this.logger.err("Re-run retis with the -e switch to show full error message and stack trace.");
      this.logger.err("Re-run with the --debug switch for debug logging");
      this.logger.err("Re-run with the -s switch to show command output");
    }
    this.logger.err("1 Error(s)");
    return process.exit(1);
  }
};


/*
 * Class
 * @param logger {Logger} Logger object
 */

Failer = (function() {
  function Failer(logger) {
    this.logger = logger;
    this.options = logger.options;
    this.fail = fail;
  }

  return Failer;

})();

module.exports = Failer;
