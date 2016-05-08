// Mkdirs
/*eslint no-case-declarations: 0*/
/*eslint no-empty-pattern: 0*/

/**
 * Module dependencies
*/
const mkdirp = require('mkdirp');
const os = require('os');
/**
 * Vars
*/
// Home dir
const home = os.homedir();
// retis home
const retis = `${home}/.retis`;
const dirs = [
  retis,
  `${retis}/plugins`, // plugins
  `${retis}/plugins/.config`, // plugins config
  `${retis}/plugins/.tmp` // plugins tmp storage
];
