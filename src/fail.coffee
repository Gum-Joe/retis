# Fail build
###
# Module dependencies
###
require 'colours'
callerId = require 'caller-id'
path = require 'path'
###
# Vars
###
tab = " "
###
# Fail build
# @param err {Error} Error to fail with
###
module.exports = (err) ->
  # Format taken from Apache Maven
  @logger.err('-----------------------------------------------------------------')
  @logger.err("#{tab}BUILD FAILURE!")
  @logger.err('-----------------------------------------------------------------')
  @logger.err("#{tab}Time: #{Date()}")
  @logger.err("#{tab}At: #{path.relative(process.cwd(), callerId.getData().filePath)}::#{callerId.getData().functionName}")
  @logger.err("#{tab}Build duration: #{(Date.now() - @logger.starttime) / 100} s")
  @logger.err('-----------------------------------------------------------------')
  callerId.getData()
