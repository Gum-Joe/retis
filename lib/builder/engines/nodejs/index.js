
/*
 * Module dependencies
 */

/*
 * Vars
 */
var engine;

engine = module.exports = {};

engine.start = function(config, options, logger) {
  var npm_globals;
  if (typeof options.local !== 'undefined' && options.local === true || config.hasOwnProperty('local') && config.local === true) {
    if (config.hasOwnProperty('nvm')) {
      logger.warn('NVM versioning is not supported on local builds.');
    }
    logger.info('Running a local build...');
    if (config.hasOwnProperty('global')) {
      logger.info('Getting global dependencies...');
      if (config.global.hasOwnProperty('npm')) {
        logger.info('Getting npm globals...');
        npm_globals = config.global.npm.toString();
        return logger.info(npm_globals);
      }
    }
  } else {

    /*
     * Create bash script
     * @docker only
     */
    return logger.deb('Generating bash script...');
  }
};
