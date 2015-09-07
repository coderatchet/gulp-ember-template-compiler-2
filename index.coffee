'use strict'
through = require 'through2'
{PluginError} = require 'gulp-util'
nopt = require 'nopt'
{compile, precompile, template} = require './bower_components/ember-template-compiler'
File = require 'vinyl'
extend = require 'extend'
util = require 'util'
Duplex = require('stream').Duplex
emberPrecompile = precompile

createPluginError = (message) ->
    new PluginError 'gulp-ember-template-compiler-2', message

job = (file, contents) ->
    file = extend file, contents: emberPrecompile(contents)

exports = module.exports =
    _count: 0
    compile: (opt = msg: 'More Coffee!') ->
        # check validity of input
        # it's okay to throw here
        if typeof opt.msg isnt 'string'
            throw createPluginError 'msg param needs to be a string, dummy'

        through.obj (file, enc, done) ->
            # `file` is a vinyl object,
            # see https://npmjs.org/package/vinyl

            # pass along empty files
            if file.isNull()
                return done(null, file)

            if file.isStream()
                file.contents.on 'data', (data) ->
                file.contents.on 'end', -> console.log 'content stream has ended'
                return done(null, file)

            # this is where the magic happens
            input = file.contents.toString()
            precompiled = emberPrecompile(input, false).toString()

            done(null, extend file, contents: new Buffer(precompiled))
