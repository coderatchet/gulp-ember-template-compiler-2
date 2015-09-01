'use strict'
through = require 'through2'
{PluginError} = require 'gulp-util'
nopt = require 'nopt'
{compile, precompile} = require './lib/ember-template-compiler'
File = require 'vinyl'
extend = require 'extend'

createPluginError = (message) ->
    new PluginError 'gulp-ember-template-compiler-2', message

awesomePlugin = (opt = msg: 'More Coffee!') ->
    # check validity of input
    # it's okay to throw here
    if typeof opt.msg isnt 'string'
        throw createPluginError 'msg param needs to be a string, dummy'

    through.obj (file, enc, done) ->
        # `file` is a vinyl object,
        # see https://npmjs.org/package/vinyl

        # pass along empty files
        if file.isNull()
            @push file
            return done()

        if file.isStream()
            file.on 'data', ->
            return done()

        # this is where the magic happens
        input = file.contents.toString()
        template = precompile(input, false)
        output = extend file, contents: new Buffer(compile(template))
        console.log output.contents.toString()

        # let's pass the result along
        @push output
        done()

module.exports = awesomePlugin
