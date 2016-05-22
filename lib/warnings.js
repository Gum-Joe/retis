
/*
 * Module dependencies
 */
var Logger, _localWarnings, warn;

require('colours');

Logger = require('./logger').Logger;


/*
 * Vars
 */

warn = module.exports = {};


/*
 * Warning method
 * @param config {Object} CSON file of config
 * @param logger {Logger} Logger
 */

warn.warnings = function(config, options, logger) {
  logger.deb("Checking if everything is " + "OK".green.bold + "...");
  if (typeof options.local !== 'undefined' && options.local === true || config.hasOwnProperty('local') && config.local === true) {
    _localWarnings(config, logger);
  }
};


/*
 * Local warnings method
 * @param config {Object} CSON file of config
 * @param logger {Logger} Logger
 * @private
 */

_localWarnings = function(config, logger) {
  if (config.hasOwnProperty('nvm')) {
    logger.warn('NVM versioning is not supported on local builds.');
  }
  if (config.hasOwnProperty('rvm')) {
    return logger.warn('RVM versioning is not supported on local builds.');
  }
};
