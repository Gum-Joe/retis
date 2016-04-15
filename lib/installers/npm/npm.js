
/*
 * Module dependencies
 */
var Npm, npm;

require('colours');


/*
 * Vars
 */

npm = module.exports = {};


/*
 * Class npm
 * @param options {Object} Options
 * @param loggr {Object} Logger
 */

Npm = (function() {
  function Npm(options, logger) {
    this.options = options;
    this.logger = logger;
    this.logger.deb('Logger passed to Npm class.');
    this.npm_command = 'npm';
  }


  /*
   * Set up args
   */

  Npm.prototype.setUpArgs = function() {
    if (typeof this.options.debug !== 'undefined' && this.options.debug) {
      this.npm_args.unshift('--verbose');
    }
    if (this.npm_options.hasOwnProperty('global') && this.npm_options.global) {
      return this.npm_args.push('-g');
    }
  };


  /*
   * Install method
   * @param packages {Array} Packages to install
   * @param options {Object} Options
   */

  Npm.prototype.install = function(packages, options) {
    this.logger.deb("Fetching packages " + "[".green + " " + (packages.toString().replace(/,/g, ', ').magenta) + "  " + "]".green + "...");
    this.npm_options = options;
    this.npm_args = packages;
    this.npm_args.unshift('install');
    this.setUpArgs();
    this.logger.deb("Command: " + ("\'" + this.npm_command + "\'").green);
    this.logger.deb("NPM args: " + "[".green + " " + (this.npm_args.toString().replace(/,/g, ', ').magenta) + "  " + "]".green + "...");
  };

  return Npm;

})();

npm.Npm = Npm;
