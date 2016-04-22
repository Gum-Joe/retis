
/*
 * Module dependencies
 */
var Installer, Pip, pip, spawnSync, which,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

spawnSync = require('child_process').spawnSync;

require('colours');

which = require('which');

Installer = require('./installer').Installer;


/*
 * Vars
 */

pip = module.exports = {};


/*
 * Pip installer
 * @extends InstaLLer
 * @param options {Object} Options
 * @param loggr {Object} Logger
 */

Pip = (function(superClass) {
  extend(Pip, superClass);

  function Pip(options, logger) {
    this.options = options;
    this.logger = logger;
    this.logger.deb('Logger passed to Pip class.');
    this.pip_command = which.sync('pip');
  }


  /*
   * Set up args
   */

  Pip.prototype.setUpArgs = function() {
    if (typeof this.options.debug !== 'undefined' && this.options.debug && !this.options.noVerboseInstall) {
      return this.pip_args.push('--verbose');
    }
  };


  /*
   * Install method
   * @param packages {Array} Packages to install
   * @param options {Object} Options
   */

  Pip.prototype.install = function(packages, options) {
    var error, error1, i;
    this.logger.info("Getting pip " + "(python)".blue.bold + " global dependencies...");
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
        this.logger.info("No pip packages to install.");
        return;
      }
    }
    this.logger.deb("Fetching packages " + "[".green + " " + (packages.toString().replace(/,/g, ', ').magenta) + "  " + "]".green + "...");
    this.pip_options = options;
    this.pip_args = packages;
    this.pip_args.unshift('install');
    this.setUpArgs();
    this.logger.deb("Command: " + ("\'" + this.pip_command + "\'").green);
    this.logger.deb("Pip args: " + "[".green + " " + (this.pip_args.toString().replace(/,/g, ', ').magenta) + "  " + "]".green + "...");
    this.logger.deb('Running...');
    this.logger.running(this.pip_command.cyan + " " + (this.pip_args.toString().replace(/,/g, ' ').cyan));
    this.exec(this.pip_command, this.pip_args, function(stdout) {
      return this.logger.stdout(stdout);
    }, function(stderr) {
      if (stderr !== "") {
        return this.logger.stderr(stderr);
      }
    });
  };

  return Pip;

})(Installer);

pip.Pip = Pip;