
/*
 * Module dependencies
 */
var Installers, installers, npm;

npm = require('./npm');


/*
 * Vars
 */

installers = module.exports = {};


/*
 * Installer class
 * @param logger {Logger} Logger used
 * @param options {Object} Options
 */

Installers = (function() {
  function Installers(options, loggger) {
    this.logger = logger;
    this.options = options;
    this.logger.deb('Logger passed to Installers class.');
    this.npm = new npm.Npm(this.options, this.logger);
  }

  return Installers;

})();

installers.Installers = Installers;
