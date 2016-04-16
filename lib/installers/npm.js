
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
 * Class npm
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
      if (stderr.startsWith('npm verb') || stderr.startsWith('npm info')) {
        return this.logger.stdout(stderr);
      } else {
        if (stderr !== " ") {
          return this.logger.stderr(stderr);
        }
      }
    });
  };

  return Npm;

})(Installer);

npm.Npm = Npm;
