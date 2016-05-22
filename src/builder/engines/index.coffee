# Index of all engines
###
# Module dependencies
###
nodejs = require './nodejs/index'
ruby = require './ruby/index'
cpp = require './cpp/index'
c = require './c/index'
###
# Vars
###
engines = module.exports = {}

# Exports nodejs engine
engines.nodejs = nodejs
engines.ruby = ruby
engines.cpp = cpp
engines.c = c
