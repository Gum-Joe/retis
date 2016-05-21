
/*
 * Module dependencies
 */

/*
 * Vars
 */

/*
 * Class
 * @param logger {Logger} Logger to use
 * @param config {Object} Plugin config
 */
var Api;

Api = (function() {
  function Api(logger, config, pc) {
    this.logger = logger;
    this.config = config;
    this.pc = pc;
    this.args = logger.options;
  }

  return Api;

})();

module.exports = Api;
