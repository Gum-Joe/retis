var Logger, app, async, execBuild, fs, getDirectories, os, parseConfig, path, plugins, plugins_func, retis_plugin_dir, waituntil;

Logger = require('./logger').Logger;

fs = require('fs');

path = require('path');

parseConfig = require('./parser').parseConfig;

plugins = require('./plugins');

waituntil = require('wait-until');

os = require('os');

execBuild = require('./builder/executer').execBuild;

async = require('async');

app = module.exports = {};

retis_plugin_dir = '.retis/plugins';

retis_plugin_dir = path.join(os.homedir(), retis_plugin_dir);

plugins_func = [];


/*
 * Build method
 * @param options {Object} Options
 */

app.build = function(options) {
  var _logger, config, i, len, p, ref;
  _logger = new Logger('retis', options);
  _logger.info('Scanning for project specification...');
  _logger.deb("CWD: " + ("\'" + (process.cwd()) + "\'").green);
  config = parseConfig(options);
  if (config.hasOwnProperty('name')) {
    this.name = config.name;
  }
  if (process.platform !== 'win32' && config.hasOwnProperty('name') === false) {
    this.name = process.cwd().split("/");
  }
  if (process.platform === 'win32' && config.hasOwnProperty('name') === false) {
    this.name = process.cwd().split("\\");
  }
  _logger.deb("Received config from parser.");
  _logger.deb("Starting build...");
  _logger.info("");
  _logger.info(":---------------------------------------------:");
  if (config.hasOwnProperty('name') === false) {
    _logger.info("  Building Project \'" + this.name[this.name.length - 1] + "\'...");
  }
  if (config.hasOwnProperty('name') === true) {
    _logger.info("  Building Project \'" + this.name + "\'...");
  }
  _logger.info(":---------------------------------------------:");
  _logger.info("");
  if (config.hasOwnProperty('plugins')) {
    ref = config.plugins;
    for (i = 0, len = ref.length; i < len; i++) {
      p = ref[i];
      plugins_func.push(function() {
        return plugins.fetchPlugin(p, options, function() {
          if (p === config.plugins[config.plugins.length - 1]) {
            return execBuild(config, options, _logger);
          } else {

          }
        });
      });
    }
    async.series(plugins_func);
  }
};

getDirectories = function(srcpath) {
  return fs.readdirSync(srcpath).filter(function(file) {
    return fs.statSync(path.join(srcpath, file)).isDirectory();
  });
};
