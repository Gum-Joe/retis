
/*
 * Module dependencies
 */
var builder, engines, plugins;

engines = require('./engines/index');

plugins = require('../plugins/exec');

require('colours');


/*
 * Vars
 */

builder = module.exports = {};


/*
 * Execute method
 */

builder.execBuild = function(config, options, logger) {
  var engine, language;
  language = config.language;
  logger.deb('Starting build for the correct language.');
  logger.deb("Language: " + ("\'" + config.language + "\'").green);
  if (language === 'nodejs') {
    engine = new engines.nodejs.Builder(config, options, logger);
  }
  if (language === 'ruby') {
    engine = new engines.ruby.Builder(config, options, logger);
  }
  plugins.run('before:build', logger, config);
  logger.deb("Running defaults...");
  engine["default"]();
  logger.deb("Running build...");
  engine.start();
  return plugins.run('after:build', logger, config);
};
