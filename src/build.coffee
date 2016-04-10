# Build file for retis

# Module dependencies
{Logger} = require './logger'
# Vars
app = module.exports = {}
logger = new Logger('retis')

###
# Build method
# @param options {Object} Options
###
app.build = (options) ->
  console.log 'Building'
