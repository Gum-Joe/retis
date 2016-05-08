# File for download list
###
# Module dependencies
###
CSON = require 'cson'
fs = require 'fs'
{Logger} = require '../logger'
path = require 'path'
os = require 'os'
###
# Vars
###
list = module.exports = {}
###
# Add method
# @param url {String} url to add
# @param options {Object} logger options
###
list.add = (url, options) ->
  logger = new Logger('retis', options)
  list_file = path.join(os.homedir(), '.retis/plugins/.config/downloadlist.cson')
  logger.deb("Adding #{url} to list...")
  if fs.existsSync(list_file) == false
    # body...
    logger.deb("Creating download list file in #{"\'#{list_file}\'".green}...")
    fs.writeFileSync(list_file, 'urls: []', 'utf8')
    logger.deb("Created download list file in #{"\'#{list_file}\'".green}.")
  current_file = CSON.parse(fs.readFileSync(list_file))
  # Push
  current_file.urls.push url
  # Write back
  CSON.createCSONString current_file, {}, (err, result) ->
    throw err if err
    # Write out
    fs.writeFileSync(list_file, result, 'utf8')
  return

###
# Check method
# @param url {String} url to check
# @param options {Object} Options
###
list.check = (url, options) ->
  logger = new Logger('retis', options)
  list_file = path.join(os.homedir(), '.retis/plugins/.config/downloadlist.cson')
  if fs.existsSync(list_file) == false
    # body...
    logger.deb("Creating download list file in #{"\'#{list_file}\'".green}...")
    fs.openSync(list_file, 'w+')
    fs.writeFileSync(list_file, 'urls: []', 'utf8')
    logger.deb("Created download list file in #{"\'#{list_file}\'".green}.")
  current_file = CSON.parse(fs.readFileSync(list_file))
  if url in current_file.urls
    # body...
    return true
  else
    return false
