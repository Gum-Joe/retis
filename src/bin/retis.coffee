#!/usr/bin/env coffee
com = require 'commander'
pack = require '../package.json'

com
  .version pack.version
  .parse process.argv
