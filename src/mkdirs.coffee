# mkdirs + files
###
# Module dependencies
###
mkdirp = require 'mkdirp'
path = require 'path'
fs = require 'fs'
os = require 'os'
###
# Vars
###
retis_loc = path.join(process.cwd(), '.retis')
retis_home = path.join(os.homedir(), '.retis')
retis_plugin_dir = "#{retis_home}/plugins"
list = [
  retis_home,
  retis_plugin_dir,
  "#{retis_plugin_dir}/.tmp",
  "#{retis_plugin_dir}/.tmp/download",
  "#{retis_plugin_dir}/.tmp/extract",
  "#{retis_plugin_dir}/.config",
  retis_loc
]
files = [
  { name: "#{retis_loc}/config.cson", contents: "file: \"config.cson\"" }
]
###
# Mkdirs
###
module.exports = (logger) ->
  # Loop through array
  # Making each dir if no exsitant.
  logger.deb("Making directories if they do not exist...")
  for m in list
    if not fs.existsSync m
      logger.deb("Creating dir #{m}...")
      mkdirp(m, (err) ->
        throw err if err
      )
      logger.deb("Created dir #{m}.")
    if m == list[list.length - 1]
      logger.deb("Done making directories.")

  # Making each file if no exsitant.
  logger.deb("Making files if they do not exist...")
  for m in files
    if not fs.existsSync m.name
      logger.deb("Creating file #{m.name}...")
      #fs.openSync(m.name, 'w+')
      logger.deb("Adding contents to file #{m.name}...")
      logger.deb("Contents: #{m.contents}")
      fs.writeFileSync(m.name, m.contents)
      logger.deb("Created file #{m.name}.")
    if m == files[files.length - 1]
      logger.deb("Done making file.")
