# Os stuff
###
# Module dependencies
###
os_mod = require 'os'
###
# Vars
###
ose = module.exports = {}
###
# Validate OS
# @param os {String} OS
# @param logger {Logger} Logger
###
ose.validateOS = (os, logger) ->
  if os != 'Linux' && os != 'OSX' && os != 'Windows'
    logger.err "Invalid OS #{"\'#{os}\'".red.bold}!"
    logger.err "Should be either #{"Linux"}, #{"Windows"} or #{"OSX"}."
    throw new Error "Invalid OS #{os}! Should be either \'Linux\', \'OSX\' or \'Windows\'."
