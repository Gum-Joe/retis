
/*
 * Module dependencies
 */
var Build, Builder, engine, version,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

version = require('../../../../package').version;

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
    var lang_col;
    this.name = 'cpp';
    this.build_defaults = {
      install: {
        cmd: './configure',
        args: ['']
      },
      build: {
        cmd: 'make',
        args: ['-C .']
      },
      post_build: {
        cmd: 'make',
        args: ['install']
      }
    };
    lang_col = 'magenta';
    this.ph.log('engine', version, {
      prefix: '>> ',
      suffix: ' >>',
      noSpace: true
    });
    this.ph.log("engines-" + this.name, version, {
      prefix: '<< ',
      suffix: ' >>',
      noSpace: true
    });
    this.logger.info("");
    this.logger.info(" Building using engine " + this.name[lang_col].bold + "...");
    this.logger.info("");
    if (typeof this.options.local !== 'undefined' && this.options.local === true || this.config.hasOwnProperty('local') && this.config.local === true) {
      this.logger.deb("Running a local " + this.name + " build...");
      if (this.property('use_script')) {
        return this._createScript();
      } else {
        return this.build(this.build_defaults);
      }
    } else {

      /*
       * Create bash script
       * @docker only
       */
      return this.logger.deb('Generating bash script...');
    }
  };


  /*
   * Create script
   * @deprecated
   * @private
   */

  Builder.prototype._createScript = function() {
    var bui, i, ins, j, k, l, len, len1, len2, len3, len4, len5, m, n, posb, posi, preb, prei, ref, ref1, ref2, ref3, ref4, ref5;
    this.createScript();
    if (this.config.hasOwnProperty('pre_install')) {
      this.pre_install = this.config.pre_install;
      this.logger.deb("Adding pre_install commands...");
      this.script.echo("");
      this.script.echo("\'Running pre install command(s)...\'".green.bold);
      if (typeof this.pre_install === 'string') {
        this.script.add(this.config.pre_install);
      } else if (typeof this.pre_install === 'array' || this.pre_install.hasOwnProperty('length')) {
        ref = this.pre_install;
        for (i = 0, len = ref.length; i < len; i++) {
          prei = ref[i];
          this.script.add(prei);
        }
      } else {
        this.logger.err("Expected pre_install command(s) to be " + "\'string\'".green.bold + " or " + "\'array\'".magenta.bold + " but got " + ("\'" + (typeof this.pre_install) + "\'").yellow.bold + "!");
        throw new TypeError("Expected pre_install command(s) to be \'string\' or \'array\' but got \'" + (typeof this.pre_install) + "\'!");
      }
    }
    if (this.config.hasOwnProperty('install')) {
      this.install = this.config.install;
      this.logger.deb("Adding install commands...");
      this.script.echo("");
      this.script.echo("\'Running install command(s)...\'".green.bold);
      if (typeof this.install === 'string') {
        this.script.add(this.config.install);
      } else if (typeof this.install === 'array' || this.install.hasOwnProperty('length')) {
        ref1 = this.install;
        for (j = 0, len1 = ref1.length; j < len1; j++) {
          ins = ref1[j];
          this.script.add(ins);
        }
      } else {
        this.logger.err("Expected install command(s) to be " + "\'string\'".green.bold + " or " + "\'array\'".magenta.bold + " but got " + ("\'" + (typeof this.install) + "\'").yellow.bold + "!");
        throw new TypeError("Expected install command(s) to be \'string\' or \'array\' but got \'" + (typeof this.install) + "\'!");
      }
    }
    if (this.config.hasOwnProperty('post_install')) {
      this.post_install = this.config.post_install;
      this.logger.deb("Adding post_install commands...");
      this.script.echo("");
      this.script.echo("\'Running post install command(s)...\'".green.bold);
      if (typeof this.post_install === 'string') {
        this.script.add(this.config.post_install);
      } else if (typeof this.post_install === 'array' || this.post_install.hasOwnProperty('length')) {
        ref2 = this.post_install;
        for (k = 0, len2 = ref2.length; k < len2; k++) {
          posi = ref2[k];
          this.script.add(posi);
        }
      } else {
        this.logger.err("Expected post_install command(s) to be " + "\'string\'".green.bold + " or " + "\'array\'".magenta.bold + " but got " + ("\'" + (typeof this.post_install) + "\'").yellow.bold + "!");
        throw new TypeError("Expected post_install command(s) to be \'string\' or \'array\' but got \'" + (typeof this.post_install) + "\'!");
      }
    }
    if (this.config.hasOwnProperty('pre_build')) {
      this.pre_build = this.config.pre_build;
      this.logger.deb("Adding pre_build commands...");
      this.script.echo("");
      this.script.echo("\'Running pre build command(s)...\'".green.bold);
      if (typeof this.pre_build === 'string') {
        this.script.add(this.config.pre_build);
      } else if (typeof this.pre_build === 'array' || this.pre_build.hasOwnProperty('length')) {
        ref3 = this.pre_build;
        for (l = 0, len3 = ref3.length; l < len3; l++) {
          preb = ref3[l];
          this.script.add(preb);
        }
      } else {
        this.logger.err("Expected pre_install command(s) to be " + "\'string\'".green.bold + " or " + "\'array\'".magenta.bold + " but got " + ("\'" + (typeof this.pre_build) + "\'").yellow.bold + "!");
        throw new TypeError("Expected pre_install command(s) to be \'string\' or \'array\' but got \'" + (typeof this.pre_build) + "\'!");
      }
    }
    if (this.config.hasOwnProperty('build')) {
      this.build = this.config.build;
      this.logger.deb("Adding build commands...");
      this.script.echo("");
      this.script.echo("\'Running build command(s)...\'".green.bold);
      if (typeof this.build === 'string') {
        this.script.add(this.config.build);
      } else if (typeof this.build === 'array' || this.build.hasOwnProperty('length')) {
        ref4 = this.build;
        for (m = 0, len4 = ref4.length; m < len4; m++) {
          bui = ref4[m];
          this.script.add(bui);
        }
      } else {
        this.logger.err("Expected build command(s) to be " + "\'string\'".green.bold + " or " + "\'array\'".magenta.bold + " but got " + ("\'" + (typeof this.build) + "\'").yellow.bold + "!");
        throw new TypeError("Expected build command(s) to be \'string\' or \'array\' but got \'" + (typeof this.build) + "\'!");
      }
    }
    if (this.config.hasOwnProperty('post_build')) {
      this.post_build = this.config.post_build;
      this.logger.deb("Adding post_build commands...");
      this.script.echo("");
      this.script.echo("\'Running post build command(s)...\'".green.bold);
      if (typeof this.post_build === 'string') {
        this.script.add(this.config.post_build);
      } else if (typeof this.post_build === 'array' || this.post_build.hasOwnProperty('length')) {
        ref5 = this.post_build;
        for (n = 0, len5 = ref5.length; n < len5; n++) {
          posb = ref5[n];
          this.script.add(posb);
        }
      } else {
        this.logger.err("Expected post_build command(s) to be " + "\'string\'".green.bold + " or " + "\'array\'".magenta.bold + " but got " + ("\'" + (typeof this.post_build) + "\'").yellow.bold + "!");
        throw new TypeError("Expected post_build command(s) to be \'string\' or \'array\' but got \'" + (typeof this.post_build) + "\'!");
      }
    }
    return this.script.runScript();
  };

  return Builder;

})(Build);

engine.Builder = Builder;
