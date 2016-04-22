
/*
 * Module dependencies
 */
var Gem, Installers, Npm, Pip, installers;

Npm = require('./npm').Npm;

Gem = require('./gem').Gem;

Pip = require('./pip').Pip;


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
    this.npm = new Npm(this.options, this.logger);
    this.gem = new Gem(this.options, this.logger);
    this.pip = new Pip(this.options, this.logger);
  }

  return Installers;

})();

installers.Installers = Installers;
