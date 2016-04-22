
/*
 * Module dependencies
 */
var Build, Builder, engine,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Build = require('../../../classes/build').Build;


/*
 * Vars
 */

engine = module.exports = {};


/*
 * Engine class
 * @extends build
 * @class
 */

Builder = (function(superClass) {
  extend(Builder, superClass);

  function Builder() {
    return Builder.__super__.constructor.apply(this, arguments);
  }

  Builder.prototype.start = function() {
    if (typeof this.options.local !== 'undefined' && this.options.local === true || this.config.hasOwnProperty('local') && this.config.local === true) {
      this.logger.info('Running a local build...');
      if (this.config.hasOwnProperty('global')) {
        return this.installGlobals();
      }
    } else {

      /*
       * Create bash script
       * @docker only
       */
      return this.logger.deb('Generating bash script...');
    }
  };

  return Builder;

})(Build);

engine.Builder = Builder;
