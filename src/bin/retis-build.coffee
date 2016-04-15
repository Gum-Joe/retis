#!/usr/bin/env coffee
# CLI
com = require 'commander'
pack = require '../package.json'
app = require '../lib/main.js'

# Setup
com
  .option '-c, --cwd <dir>', 'Working directory'
  .option '--debug', 'Debug logging'
  .option '-d, --docker', 'Run in a docker container'
  .option '-f, --file <file>', 'Specify a .retis.yml to use.'
  .option '-l, --local', 'Don\'t run in a docker container'
  .option '-v, --verbose', 'Verbose logging'
  .parse process.argv

if typeof com.cwd != 'undefined'
  # body...
  process.chdir com.cwd
if typeof process.env.RETIS_CWD != 'undefined'
  # body...
  process.chdir process.env.RETIS_CWD

app.build file: com.file, debug: com.debug || com.verbose, local: com.local || true, docker: com.docker || false
