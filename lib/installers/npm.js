
/*
 * Module dependencies
 */
var Installer, Npm, npm, spawnSync, which,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

spawnSync = require('child_process').spawnSync;

require('colours');

which = require('which');

Installer = require('./installer').Installer;


/*
 * Vars
 */

npm = module.exports = {};


/*
 * Npm installer
 * @extends InstaLLer
 * @param options {Object} Options
 * @param loggr {Object} Logger
 */

Npm = (function(superClass) {
  extend(Npm, superClass);

  function Npm(options, logger) {
    this.options = options;
    this.logger = logger;
    this.logger.deb('Logger passed to Npm class.');
    this.npm_command = which.sync('npm');
  }


  /*
   * Set up args
   */

  Npm.prototype.setUpArgs = function() {
    if (typeof this.options.debug !== 'undefined' && this.options.debug && !this.options.noVerboseInstall) {
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
    var error, error1, i;
    this.logger.info("Getting npm " + "(nodejs)".green.bold + " global dependencies...");
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
        this.logger.info("No npm packages to install.");
        return;
      }
    }
    this.logger.deb("Fetching packages " + "[".green + " " + (packages.toString().replace(/,/g, ', ').magenta) + "  " + "]".green + "...");
    this.npm_options = options;
    this.npm_args = packages;
    this.npm_args.unshift('install');
    this.setUpArgs();
    this.logger.deb("Command: " + ("\'" + this.npm_command + "\'").green);
    this.logger.deb("NPM args: " + "[".green + " " + (this.npm_args.toString().replace(/,/g, ', ').magenta) + "  " + "]".green + "...");
    this.logger.deb('Running...');
    this.logger.running(this.npm_command.cyan + " " + (this.npm_args.toString().replace(/,/g, ' ').cyan));
    this.exec(this.npm_command, this.npm_args, function(stdout) {
      return this.logger.stdout(stdout);
    }, function(stderr) {
      if (stderr.startsWith('npm ERR!') || stderr.startsWith('npm ERR') || stderr.startsWith('npm err!') || stderr.startsWith('npm err')) {
        return this.logger.stderr(stderr);
      } else {
        if (stderr !== "") {
          return this.logger.stdout(stderr);
        }
      }
    });
  };

  return Npm;

})(Installer);

npm.Npm = Npm;
