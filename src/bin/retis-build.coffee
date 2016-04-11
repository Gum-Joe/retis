#!/usr/bin/env coffee
# CLI
com = require 'commander'
pack = require '../package.json'
app = require '../lib/main.js'

# Setup
com
  .option '--debug', 'Debug logging'
  .option '-c, --cwd <dir>', 'Working directory'
  .option '-f, --file <file>', 'Specify a .retis.yml to use.'
  .parse process.argv

if typeof com.cwd != 'undefined'
  # body...
  process.chdir com.cwd
if typeof process.env.RETIS_CWD != 'undefined'
  # body...
  process.chdir process.env.RETIS_CWD

app.build file: com.file, debug: com.debug
