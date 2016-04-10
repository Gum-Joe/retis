#!/usr/bin/env coffee
# CLI
com = require 'commander'
pack = require '../package.json'
app = require '../lib/main.js'

# Setup
com
  .option '-f, --file <file>', 'Specify a .retis.yml to use.'
  .parse process.argv

app.build file: com.file
