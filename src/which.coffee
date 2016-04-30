# Which files
###
# Module dependencies
###
which = require 'which'
require 'colours'
{Logger} = require './logger'
which = which.sync
###
# Vars
###
logger = new Logger('retis', {})
###
# Which function
# @param cmd {String} Command to check
###
module.exports = (cmd) ->
  try
    return which cmd
  catch err
    logger.warn "Command #{cmd.cyan.bold} not found on system. Is it installed?"
    return cmd
