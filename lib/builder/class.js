
/*
 * Module dependencies
 */
var Build, Installers;

Installers = require('../installers/index').Installers;


/*
 * Build class
 * @param config {Object} config
 * @param options {Object} Options from cli
 * @param logger {Logger} logger
 */

Build = (function() {
  function Build(config, options, logger) {
    this.config = config;
    this.logger = logger;
    this.options = options;
    this.logger.deb('Logger passed to Build class.');
    this.installers = new Installers(this.options, this.logger);
  }


  /*
   * Install globals
   */

  Build.prototype.installGlobals = function() {
    this.global_deps = this.config.global;
    this.logger.info('Getting global dependencies...');
    if (this.global_deps.hasOwnProperty('npm')) {
      this.logger.deb('Getting npm globals...');
      this.installers.npm.install(this.global_deps.npm, {
        global: true
      });
    }
  };

  return Build;

})();

module.exports = {
  Build: Build
};
