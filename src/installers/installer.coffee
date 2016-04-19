# Installer class
###
# Module dependencies
###
{spawnSync} = require 'child_process'
###
# Vars
###
installer = module.exports = {}

# Class
class Installer
  ###
  # Exec method
  # @param command {String} Command to run
  # @param args {Array} Args
  # @param onStdout {Function} Runs when we get stdout
  # @param onStderr {Function} Runs when we get stderr
  ###
  exec: (command, args, onStdout, onStderr) ->
    @process = spawnSync command, args
    @logger.deb("PID: #{@process.pid}")
    @stdout = @process.stdout.toString('utf8').split('\n')
    @stderr = @process.stderr.toString('utf8').split('\n')
    for o in @stdout
      # body...
      onStdout(o)
    for oe in @stderr
      # body...
      onStderr(oe)
    # Catch errors
    throw @process.error if @process.error
    if @process.status != 0
      # body...
      throw new Error("Command #{"\'#{command}\'".green} exited with #{@process.status.toString().yellow}")

# Export
installer.Installer = Installer
