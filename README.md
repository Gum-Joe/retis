Another bit of early experimentation I did with JS & CoffeeScript - the first time I think I built a plug-ins system.

# retis [![Build Status](https://travis-ci.org/Gum-Joe/retis.svg?branch=master)](https://travis-ci.org/Gum-Joe/retis) [![Coverage Status](https://coveralls.io/repos/github/Gum-Joe/retis/badge.svg?branch=master)](https://coveralls.io/github/Gum-Joe/retis?branch=master) [![Code Climate](https://codeclimate.com/github/Gum-Joe/retis/badges/gpa.svg)](https://codeclimate.com/github/Gum-Joe/retis) [![Dependency Status](https://david-dm.org/Gum-Joe/retis.svg)](https://david-dm.org/Gum-Joe/retis) [![devDependency Status](https://david-dm.org/Gum-Joe/retis/dev-status.svg)](https://david-dm.org/Gum-Joe/retis#info=devDependencies)
The advanced build service for everyone - including dudes!

Development is currently paused, come back to this
**NOTICE:** Currently in active development. Not all features may be available. There may be bugs; if you find a bug, please file an issue.

# Requirements

- `node`: `>=6.0.0`

# Getting Started
```bash
$ npm install -g retis
```
# Usage
```
retis <target> [options]
```
Targets:

- `build`

Use `retis <target> --help` for options for a specific target

# How do I use retis?
Use a config file. Put this in a `.retis.yml`:
```yaml
# Plugins that you can use
# Either ran before or after build
plugins:
  - "https://raw.githubusercontent.com/jakhu/retis-tester-1/test/psf.cson"
name: "retis-example" # Name of your project
out_dir: "./build" # Build dir
# Coming soon: Source code pulling
scm:
  type: "git"
  remote: "origin"
  user:
    name: Gum-Joe
# Local build?
local: true
# Language of your project (nodejs, ruby, cpp or c)
language: "nodejs"

# CMDs
# Put your commands as each property
pre_install: echo pre_install
install:
  - 'echo install'
  - 'echo You can even have multiple commands!'
post_install: 'echo post'
build: 'echo build'
post_build: 'echo post'

# Global deps (npm, gem or pip)
global:
  npm:
    - "buildup"
  gem:
    - "sass"
  pip:
    - "request"
sh:
  hide_env: false

# Environment variables for your build
env:
  - TEST=test

```

# Compiling
```bash
# Compile libs
coffee --bare -o lib -c src
# Compile bin
coffee --bare -o bin -c src/bin
```

# Tests
`npm test`

# Creating your first project
Coming soon!

# Making plugins
Coming soon. Please see [jakhu/retis-tester-1](https://github.com/jakhu/retis-tester-1) for an example
