
/*
 * Module dependencies
 */
var Installer, installer, spawnSync;

spawnSync = require('child_process').spawnSync;


/*
 * Vars
 */

installer = module.exports = {};

Installer = (function() {
  function Installer() {}


  /*
   * Exec method
   * @param command {String} Command to run
   * @param args {Array} Args
   * @param onStdout {Function} Runs when we get stdout
   * @param onStderr {Function} Runs when we get stderr
   */

  Installer.prototype.exec = function(command, args, onStdout, onStderr) {
    var i, j, len, len1, o, oe, ref, ref1;
    this.process = spawnSync(command, args);
    this.logger.deb("PID: " + this.process.pid);
    this.stdout = this.process.stdout.toString('utf8').split('\n');
    this.stderr = this.process.stderr.toString('utf8').split('\n');
    ref = this.stdout;
    for (i = 0, len = ref.length; i < len; i++) {
      o = ref[i];
      onStdout(o);
    }
    ref1 = this.stderr;
    for (j = 0, len1 = ref1.length; j < len1; j++) {
      oe = ref1[j];
      onStderr(oe);
    }
    if (this.process.error) {
      throw this.process.error;
    }
  };

  return Installer;

})();

installer.Installer = Installer;
