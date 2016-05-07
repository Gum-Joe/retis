#!/usr/bin/env coffee
# CLI
com = require 'commander'
app = require '../lib/main.js'
{Logger} = require '../lib/logger'
# Start
console.time("starting")
# CLI Setup
com
  .option '-c, --cwd <dir>', 'Working directory'
  .option '-d, --docker', 'Run in a docker container'
  .option '-D, --prop [property]', 'Add a property the build. Use the form type:NAME=VALUE. Types: env'
  .option '-e, --trace', 'Show full error message and stack trace on error'
  .option '-f, --file <file>', 'Specify a .retis.yml to use'
  .option '-l, --local', 'Don\'t run in a docker container'
  .option '-o, --out-dir <dir>', 'Specify the build output directory'
  .option '-q, --quiet', 'Disable displaying full error messages'
  .option '-s, --silent', 'No logging'
  .option '-v, --verbose', 'Verbose logging'
  .option '--debug', 'Debug logging'
  .option '--force', 'Force build tasks'
  .option '--hide-output', 'Hide command output'
  .option '--no-verbose-install', 'Disable verbose logging for installation of dependencies'
  .option '--os <os>', 'Specify an OS for running the build'
  .option '--show-output', 'Shows the output of build commands'
  .option '--show-pip-output', 'Show pip installation output'
  .parse process.argv

# Function for getting props
getProps = ->
  results = []
  i = 0
  while i < com.rawArgs.length
    if com.rawArgs[i] == '-D' || com.rawArgs[i] == '--prop'
      results.push com.rawArgs[ i + 1 ]
    i++
  return results

# Options object
options = {
  file: com.file,
  debug: com.debug || com.verbose,
  local: com.local || true,
  docker: com.docker || false,
  noVerboseInstall: com.noVerboseInstall || true, # Remove true default on release,
  force: com.force,
  hideOutput: com.hideOutput,
  showPipOutput: com.showPipOutput || false,
  outDir: com.outDir,
  os: com.os,
  props: getProps(),
  showOutput: com.showOutput || com.debug,
  trace: com.trace,
  quite: com.quite,
  silent: com.silent
}

# Private logger
_logger = new Logger('retis', options)

if typeof com.cwd != 'undefined'
  # body...
  process.chdir com.cwd
if typeof process.env.RETIS_CWD != 'undefined'
  # body...
  process.chdir process.env.RETIS_CWD
app.build options
# exit
process.on 'exit', (code) ->
  if code == 0
    tab = " "
    memory = process.memoryUsage()
    mems = "#{Math.round(memory.heapUsed / 1024 / 1024)} / #{Math.round(memory.heapTotal / 1024 / 1024)} MB "
    _logger.info("")
    _logger.info('-----------------------------------------------------------------')
    _logger.info("#{tab}BUILD SUCCESS!")
    _logger.info('-----------------------------------------------------------------')
    _logger.info("#{tab}Finished at: #{Date()}")
    _logger.info("#{tab}Memory: #{mems}")
    _logger.info("#{tab}Build duration: #{(Date.now() - _logger.starttime) / 100} s")
    _logger.info('-----------------------------------------------------------------')
