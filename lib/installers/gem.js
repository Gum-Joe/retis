
/*
 * Module dependencies
 */
var Gem, Installer, gem, spawnSync, which,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

spawnSync = require('child_process').spawnSync;

require('colours');

which = require('which');

Installer = require('./installer').Installer;


/*
 * Vars
 */

gem = module.exports = {};


/*
 * Class npm
 * @param options {Object} Options
 * @param loggr {Object} Logger
 */

Gem = (function(superClass) {
  extend(Gem, superClass);

  function Gem(options, logger) {
    this.options = options;
    this.logger = logger;
    this.logger.deb('Logger passed to Gem class.');
    this.gem_command = which.sync('gem');
  }


  /*
   * Set up args
   */

  Gem.prototype.setUpArgs = function() {
    if (typeof this.options.debug !== 'undefined' && this.options.debug && !this.options.noVerboseInstall) {
      return this.gem_args.push('--verbose');
    }
  };


  /*
   * Install method
   * @param packages {Array} Packages to install
   * @param options {Object} Options
   */

  Gem.prototype.install = function(packages, options) {
    var error, error1, i;
    if (typeof this.options.force === 'undefined') {
      i = 0;
      while (i < packages.length) {
        try {
          which.sync(i);
        } catch (error1) {
          error = error1;
          if (error) {
            this.logger.deb("Package " + ("\'" + packages[i] + "\'").green + " already installed. Skipping...");
            delete packages[i];
          }
        }
        i++;
      }
      if (packages.length === 1 && packages[0] === "" || packages.length === 0 || typeof packages !== 'array') {
        this.logger.deb("No gem packages to install.");
        return;
      }
    }
    this.logger.deb("Fetching packages " + "[".green + " " + (packages.toString().replace(/,/g, ', ').magenta) + "  " + "]".green + "...");
    this.gem_options = options;
    this.gem_args = packages;
    this.gem_args.unshift('install');
    this.setUpArgs();
    this.logger.deb("Command: " + ("\'" + this.gem_command + "\'").green);
    this.logger.deb("Gem args: " + "[".green + " " + (this.gem_args.toString().replace(/,/g, ', ').magenta) + "  " + "]".green + "...");
    this.logger.deb('Running...');
    this.logger.running(this.gem_command.cyan + " " + (this.gem_args.toString().replace(/,/g, ' ').cyan));
    this.exec(this.gem_command, this.gem_args, function(stdout) {
      return this.logger.stdout(stdout);
    }, function(stderr) {
      if (stderr !== "") {
        return this.logger.stderr(stderr);
      }
    });
  };

  return Gem;

})(Installer);

gem.Gem = Gem;
