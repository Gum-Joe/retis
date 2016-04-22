
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
      console.log('');
      this.logger.deb('Getting npm (nodejs) globals...');
      this.installers.npm.install(this.global_deps.npm, {
        global: true
      });
    }
    if (this.global_deps.hasOwnProperty('gem')) {
      console.log('');
      this.logger.deb('Getting gem (ruby) globals...');
      this.installers.gem.install(this.global_deps.gem);
    }
    if (this.global_deps.hasOwnProperty('pip')) {
      console.log('');
      this.logger.deb('Getting pip (python) globals...');
      this.installers.pip.install(this.global_deps.pip);
    }
  };

  return Build;

})();

module.exports = {
  Build: Build
};
