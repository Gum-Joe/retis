
/*
 * Module dependencies
 */
var builder, engines;

engines = require('./engines/index');

require('colours');


/*
 * Vars
 */

builder = module.exports = {};


/*
 * Execute method
 */

builder.execBuild = function(config, options, logger) {
  var language;
  language = config.language;
  logger.deb('Starting build for the correct language.');
  logger.deb("Language: " + ("\'" + config.language + "\'").green);
  if (language === 'nodejs') {
    return new engines.nodejs.Builder(config, options, logger).start();
  }
};
