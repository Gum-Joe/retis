
/*
 * Module dependencies
 */
var Build, Failer, Installers, PluginHead, RunScript, generators, os, spawnSync, sq, version;

os = require('os');

generators = require('../generators');

Failer = require('../fail');

Installers = require('../installers').Installers;

spawnSync = require('child_process').spawnSync;

version = require('../../package').version;

RunScript = require('./script').RunScript;

PluginHead = require('../plugin-head').PluginHead;


/*
 * Vars
 */

sq = "\'";


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
    this.ph = new PluginHead(this.logger);
    if (!(os.platform() !== 'win32' || 'darwin') || (options.hasOwnProperty('os') && typeof options.os !== 'undefined' && options.os !== 'Windows' && options.os !== 'OSX') || (config.hasOwnProperty('os') && config.os !== 'Windows' && config.os !== 'OSX')) {
      this.os = "Linux";
    }
    if (!(os.platform() !== 'win32' || 'linux') || (options.hasOwnProperty('os') && typeof options.os !== 'undefined' && options.os !== 'Windows' && options.os !== 'Linux') || (config.hasOwnProperty('os') && config.os !== 'Windows' && config.os !== 'Linux')) {
      this.os = "OSX";
    }
    if (!(os.platform() !== 'darwin' || 'linux') || (options.hasOwnProperty('os') && typeof options.os !== 'undefined' && options.os !== 'OSX' && options.os !== 'Linux') || (config.hasOwnProperty('os') && config.os !== 'OSX' && config.os !== 'Linux')) {
      this.os = "Windows";
    }
    this.fail = new Failer(this.logger);
  }


  /*
   * Install globals
   */

  Build.prototype.installGlobals = function() {
    this.ph.log("retis-globals", version);
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
    console.log('');
  };


  /*
   * Create script
   */

  Build.prototype.createScript = function() {
    this.logger.info("");
    this.ph.log("retis-script", version);
    this.logger.info("Generating run script...");
    this.script = new RunScript(this.logger, this.options, this.config);
    this.script.applyEnv();
    return this.script.applyUserEnv();
  };


  /*
   * Check for a property
   * @param prop {String} Property to check for
   * @param value {String} Value to check for
   * @return bolean
   */

  Build.prototype.property = function(prop, value) {
    return typeof this.options[prop] !== 'undefined' && this.options[prop] === value || this.config.hasOwnProperty(prop) && this.config[prop] === value;
  };


  /*
   * Build it
   * @param defaults {String} default
   */

  Build.prototype.build = function(defaults) {
    var cmd, i, results;
    this.logger.deb("Building...");
    cmd = new generators.Command(this.config, defaults, this.logger);
    this.pre_install_cmd = cmd.generate('pre_install');
    this.pre_install_args = cmd.args('pre_install');
    this.install_cmd = cmd.generate('install');
    this.install_args = cmd.args('install');
    this.post_install_cmd = cmd.generate('post_install');
    this.post_install_args = cmd.args('post_install');
    this.pre_build_cmd = cmd.generate('pre_build');
    this.pre_build_args = cmd.args('pre_build');
    this.build_cmd = cmd.generate('build');
    this.build_args = cmd.args('build');
    this.post_build_cmd = cmd.generate('post_build');
    this.post_build_args = cmd.args('post_build');
    this.logger.info("");
    this.ph.log("retis-build", version);
    this.logger.deb("Exporting env...");
    this._applyEnv();
    if (this.pre_install_cmd && this.pre_install_args) {
      if (typeof this.pre_install_cmd === 'string') {
        this.logger.info("Running pre_install command...");
        this.exec(this.pre_install_cmd, this.pre_install_args);
        console.log("");
      } else {
        this.logger.info("Running pre_install commands...");
        i = 0;
        while (i < this.pre_install_cmd.length) {
          this.exec(this.pre_install_cmd[i], this.pre_install_args[i]);
          console.log("");
          i++;
        }
      }
    }
    if (this.install_cmd && this.install_args) {
      if (typeof this.install_cmd === 'string') {
        this.logger.info("Running install command...");
        this.exec(this.install_cmd, this.install_args);
        console.log("");
      } else {
        this.logger.info("Running install commands...");
        i = 0;
        while (i < this.install_cmd.length) {
          this.exec(this.install_cmd[i], this.install_args[i]);
          console.log("");
          i++;
        }
      }
    }
    if (this.post_install_cmd && this.post_install_args) {
      if (typeof this.post_install_cmd === 'string') {
        this.logger.info("Running post_install command...");
        this.exec(this.post_install_cmd, this.post_install_args);
        console.log("");
      } else {
        this.logger.info("Running post_install commands...");
        i = 0;
        while (i < this.post_install_cmd.length) {
          this.exec(this.post_install_cmd[i], this.post_install_args[i]);
          console.log("");
          i++;
        }
      }
    }
    if (this.pre_build_cmd && this.pre_build_args) {
      if (typeof this.pre_build_cmd === 'string') {
        this.logger.info("Running pre_build command...");
        this.exec(this.pre_build_cmd, this.pre_build_args);
        console.log("");
      } else {
        this.logger.info("Running pre_build commands...");
        i = 0;
        while (i < this.pre_build_cmd.length) {
          this.exec(this.pre_build_cmd[i], this.pre_build_args[i]);
          console.log("");
          i++;
        }
      }
    }
    if (this.build_cmd && this.build_args) {
      if (typeof this.build_cmd === 'string') {
        this.logger.info("Running build command...");
        this.exec(this.build_cmd, this.build_args);
        console.log("");
      } else {
        this.logger.info("Running build commands...");
        i = 0;
        while (i < this.build_cmd.length) {
          this.exec(this.build_cmd[i], this.build_args[i]);
          console.log("");
          i++;
        }
      }
    }
    if (this.post_build_cmd && this.post_build_args) {
      if (typeof this.post_build_cmd === 'string') {
        this.logger.info("Running build command...");
        this.exec(this.post_build_cmd, this.post_build_args);
        return console.log("");
      } else {
        this.logger.info("Running build commands...");
        i = 0;
        results = [];
        while (i < this.post_build_cmd.length) {
          this.exec(this.post_build_cmd[i], this.post_build_args[i]);
          console.log("");
          results.push(i++);
        }
        return results;
      }
    }
  };


  /*
   * Init env
   * @private
   */

  Build.prototype._initEnv = function() {
    var env, env_setup, j, k, len, len1, prop, ref, ref1, results, split_prop;
    this.env = {
      RETIS_LANGUAGE: this.config.language,
      RETIS_OS: this.os,
      RETIS_CWD: process.cwd()
    };
    if (this.config.hasOwnProperty('scm')) {
      if (!this.config.scm.hasOwnProperty("type")) {
        throw new Error("No type of scm specified!");
      }
      if (this.config.scm.type !== 'git') {
        throw new Error("Scm \'" + this.config.scm.type + "\' is not supported!");
      }
      if (this.config.scm.hasOwnProperty('user') && this.config.scm.user.hasOwnProperty('name')) {
        this.env.RETIS_GIT_USER = this.config.scm.user.name;
      }
      if (!this.config.scm.hasOwnProperty('user') || !this.config.scm.user.hasOwnProperty('name')) {
        this.env.RETIS_GIT_USER = this._git(['config', 'user.name']);
      }
      this.env.RETIS_GIT_COMMIT = this._git(['rev-parse', 'HEAD']);
      this.env.RETIS_GIT_BRANCH = this._git(['rev-parse', '--abbrev-ref', 'HEAD']);
      this.env.RETIS_GIT_REMOTE = this._git('config --get remote.origin.url'.split(" "));
      if (this.config.hasOwnProperty('env')) {
        ref = this.config.env;
        for (j = 0, len = ref.length; j < len; j++) {
          env = ref[j];
          if (!env.includes("=")) {
            this.logger.err("ENV value " + sq.cyan.bold + env.cyan.bold + sq.cyan.bold + " not in the form of " + "NAME=VALUE".green.bold + "!");
            throw new Error("ENV value \'" + env + "\' not in the form of \'NAME=VALUE\'!");
          } else {
            env_setup = env.split("=");
            this.env[env_setup[0]] = env_setup[1];
          }
        }
      }
      if (typeof this.options.props !== 'undefined' && this.options.props.length > 0) {
        this.logger.deb("Adding cli props...");
        ref1 = this.options.props;
        results = [];
        for (k = 0, len1 = ref1.length; k < len1; k++) {
          prop = ref1[k];
          if (prop.startsWith('env:')) {
            this.logger.deb("Adding " + prop.green.bold + "...");
            split_prop = prop.slice(4, prop.length).split('=');
            results.push(this.env[split_prop[0]] = split_prop[1]);
          } else {
            results.push(void 0);
          }
        }
        return results;
      }
    }
  };


  /*
   * Execute
   * @param cmd {String} Command to execute
   * @param args {Array} Array of args
   */

  Build.prototype.exec = function(cmd, args) {
    var err, err_string, j, k, len, len1, ref, ref1, stderr, stdout;
    this.logger.deb("Command: " + cmd.blue.bold);
    this.logger.deb("Args: " + "[".magenta.bold + " " + (args.toString().replace(/,/g, ', ').green.bold) + " " + "]".magenta.bold);
    this.logger.running(cmd.cyan.bold + " " + (args.toString().replace(/,/g, ' ').green.bold));
    this.output = spawnSync(cmd, args);
    if (this.output.error) {
      err = this.output.error;
      if (err.code === "ENOENT") {
        err.message = "Command \'" + cmd + "\' not found!";
      }
      this.fail.fail(err);
    }
    ref = this.output.stdout.toString('utf8').split('\n');
    for (j = 0, len = ref.length; j < len; j++) {
      stdout = ref[j];
      if (stdout !== '') {
        this.logger.stdout("'" + stdout + "'");
      }
    }
    ref1 = this.output.stderr.toString('utf8').split('\n');
    for (k = 0, len1 = ref1.length; k < len1; k++) {
      stderr = ref1[k];
      if (stderr !== '') {
        this.logger.stderr(stderr);
      }
    }
    if (this.output.status > 0) {
      this.logger.err("Process exited with " + (this.output.status.toString().yellow.bold) + ".");
    }
    if (this.output.status > 0) {
      err_string = "Command " + "\'".cyan.bold + cmd.cyan.bold + " " + (args.toString().replace(/,/g, ' ').cyan.bold) + "\'".cyan.bold + " exited with " + (this.output.status.toString().yellow.bold) + "!";
      this.logger.err(err_string);
      this.logger.err("");
      return this.fail.fail(new Error("Command \'" + cmd + " " + (args.toString().replace(/,/g, ' ')) + "\' exited with " + this.output.status + "!"));
    }
  };


  /*
   * Run default stuff
   */

  Build.prototype["default"] = function() {
    if (typeof this.options.local !== 'undefined' && this.options.local === true || this.config.hasOwnProperty('local') && this.config.local === true) {
      this.logger.deb('Running a local build...');
      this.logger.deb("");
      if (this.config.hasOwnProperty('global')) {
        return this.installGlobals();
      }
    } else {
      return this.logger.info('Not running a local build. Leaving default stuff up to build engine.');
    }
  };


  /*
   * Get git output data
   * @private
   * @param args {Array} git args
   */

  Build.prototype._git = function(args) {
    return spawnSync('git', args).stdout.toString('utf8').slice(0, -1);
  };


  /*
   * Apply env
   */

  Build.prototype._applyEnv = function() {
    var env, ref, results, value;
    this._initEnv();
    ref = this.env;
    results = [];
    for (env in ref) {
      value = ref[env];
      this.logger.deb("export".magenta.bold + " " + env + "=" + value);
      results.push(process.env[env] = value);
    }
    return results;
  };

  return Build;

})();

module.exports = {
  Build: Build
};
