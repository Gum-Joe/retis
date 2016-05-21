
/*
 * Module dependencies
 */
var Api, CSON, Failer, PluginHead, _exec, fs, os, path, plug;

CSON = require('cson');

path = require('path');

fs = require('fs');

os = require('os');

Failer = require('../fail');

PluginHead = require('../plugin-head').PluginHead;

Api = require('./api');


/*
 * Vars
 */

plug = module.exports = {};


/*
 * Run plugins for a certain type
 * @param goal {String} Plugin type
 * @param logger {Logger} Logger
 */

plug.run = function(goal, logger, config) {
  var fail, i, len, pc, plugin_dir, plugins, plugins_config, plugins_dir, ref, results;
  plugins_dir = path.join(os.homedir(), '.retis', 'plugins');
  fail = new Failer(logger);
  plugins_config = path.join(process.cwd(), '.retis', 'config.cson');
  logger.deb('Running pre-build plgins (before:build)...');
  plugins = CSON.parse(fs.readFileSync(plugins_config));
  if (plugins instanceof Error) {
    fail.fail(plugins);
  }
  logger.deb("Everything " + "OK".green + ". Commencing executing...");
  ref = plugins.packages;
  results = [];
  for (i = 0, len = ref.length; i < len; i++) {
    plug = ref[i];
    plugin_dir = path.join(plugins_dir, plug);
    logger.deb("Checking plugin " + plug.green + " for running...");
    pc = CSON.parse(fs.readFileSync(path.join(plugin_dir, 'psf.cson')));
    if (pc instanceof Error) {
      fail.fail(pc);
    }
    if (pc.hasOwnProperty('type') && pc.type === goal) {
      results.push(_exec(pc, config, plugin_dir, logger));
    } else {
      results.push(logger.deb("Not executing plugin " + plug.green + "."));
    }
  }
  return results;
};


/*
 * Plugins executer
 * @param config {Object} Config
 * @param dir {String} dir for plugin
 * @param logger {Logger} Logger
 * @param fail {Failer} Failer for errors
 */

_exec = function(pc, config, dir, logger) {
  var file, head;
  head = new PluginHead(logger);
  if (!pc.hasOwnProperty('name' || typeof pc.name !== 'string')) {
    pc.name = 'retis-plugin';
  }
  if (!pc.hasOwnProperty('version' || typeof pc.version !== 'string')) {
    pc.version = '0.0.0';
  }
  logger.deb("Executing plugin " + pc.name.green + "...");
  logger.deb("Dir: " + dir.cyan);
  logger.deb("File to require: " + pc.entry.cyan);
  if (!fs.existsSync(path.join(dir, pc.entry))) {
    logger.warn("Plugin " + pc.name.green + " does not include its entry file " + pc.entry.cyan + ". " + "STOP".red + ".");
    return;
  }
  file = require(path.join(dir, pc.entry));
  head.log(pc.name, pc.version);
  file(new Api(logger, config, pc));
  return logger.info("");
};
