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
      if @options.hasOwnProperty("hideOutput") == false || @options.hasOwnProperty("hideOutput") && !(@options.hideOutput)
        onStdout(o)
      else
        @logger.deb "STDOUT for command #{"\'#{command}\'".green} hidden."
    for oe in @stderr
      # body...
      if @options.hasOwnProperty("hideOutput") == false || @options.hasOwnProperty("hideOutput") && !(@options.hideOutput)
        onStderr(o)
      else
        @logger.deb "STDERR for command #{"\'#{command}\'".green} hidden."
    # Catch errors
    throw @process.error if @process.error
    if @process.status != 0
      # body...
      @logger.err("Command #{"\'#{command}\'".green} exited with #{@process.status.toString().yellow}!")
      @logger.err("Stderr:")
      console.log ""
      for oe in @stderr
        @logger.stderr(oe)
      process.exit 1
      #throw new Error("Command #{"\'#{command}\'".green} exited with #{@process.status.toString().yellow}")

# Export
installer.Installer = Installer
