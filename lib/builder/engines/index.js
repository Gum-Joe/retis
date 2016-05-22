
/*
 * Module dependencies
 */
var c, cpp, engines, nodejs, ruby;

nodejs = require('./nodejs/index');

ruby = require('./ruby/index');

cpp = require('./cpp/index');

c = require('./c/index');


/*
 * Vars
 */

engines = module.exports = {};

engines.nodejs = nodejs;

engines.ruby = ruby;

engines.cpp = cpp;

engines.c = c;
