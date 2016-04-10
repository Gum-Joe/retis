#!/usr/bin/env coffee
# CLI
com = require 'commander'
pack = require '../package.json'
app = require '../lib/main.js'

# Setup
com
  .option '--debug', 'Debug logging'
  .option '-d, --dir <dir>', 'Working directory'
  .option '-f, --file <file>', 'Specify a .retis.yml to use.'
  .parse process.argv

if typeof com.dir != 'undefined'
  # body...
  process.cwd com.dir

app.build file: com.file, debug: com.debug, dir: com.dir
