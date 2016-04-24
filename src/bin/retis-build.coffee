#!/usr/bin/env coffee
# CLI
com = require 'commander'
pack = require '../package.json'
app = require '../lib/main.js'

# Setup
com
  .option '-c, --cwd <dir>', 'Working directory'
  .option '-d, --docker', 'Run in a docker container'
  .option '-f, --file <file>', 'Specify a .retis.yml to use'
  .option '-l, --local', 'Don\'t run in a docker container'
  .option '-o, --out-dir <dir>', 'Specify the build output directory'
  .option '-v, --verbose', 'Verbose logging'
  .option '--debug', 'Debug logging'
  .option '--force', 'Force build tasks'
  .option '--hide-output', 'Hide command output'
  .option '--no-verbose-install', 'Disable verbose logging for installation of dependencies'
  .option '--os <os>', 'Specify an OS for running the build'
  .option '--show-pip-output', 'Show pip installation output'
  .parse process.argv

if typeof com.cwd != 'undefined'
  # body...
  process.chdir com.cwd
if typeof process.env.RETIS_CWD != 'undefined'
  # body...
  process.chdir process.env.RETIS_CWD
app.build(
  {
    file: com.file,
    debug: com.debug || com.verbose,
    local: com.local || true,
    docker: com.docker || false,
    noVerboseInstall: com.noVerboseInstall || true, # Remove true default on release,
    force: com.force,
    hideOutput: com.hideOutput,
    showPipOutput: com.showPipOutput || false,
    outDir: com.outDir,
    os: com.os
  })
