(->
    childProcess = require("child_process")
    oldSpawn = childProcess.spawn
    mySpawn = ->
        console.log 'spawn called'
        console.log arguments
        oldSpawn.apply this, arguments
    childProcess.spawn = mySpawn
)()

# module dependencies
chai = require 'chai'
should = chai.should()
gulp = require 'gulp'
gutil = require 'gulp-util'
path = require 'path'
fs = require 'fs'

# const
PLUGIN_NAME = 'gulp-ember-template-compiler-2'
ERRS =
    MSG:
        'msg param needs to be a string, dummy'
    STREAM:
        'stream content is not supported'
# SUT
etc = require '../'

describe 'gulp-ember-template-compiler-2', ->
    describe 'emberTemplateCompiler2()', ->
        it 'should pass through empty files', (done) ->
            dataCounter = 0

            fakeFile = new gutil.File
                path: './test/fixture/file.js',
                cwd: './test/',
                base: './test/fixture/',
                contents: null

            stream = etc()

            stream.on 'data', (newFile) ->
                should.exist(newFile)
                should.exist(newFile.path)
                should.exist(newFile.relative)
                should.not.exist(newFile.contents)
                newFile.path.should.equal fakeFile.path
                newFile.relative.should.equal 'file.js'
                ++dataCounter

            stream.once 'end', ->
                dataCounter.should.equal 1
                done()

            stream.write fakeFile
            stream.end()

        it 'should pass through a file', (done) ->
            dataCounter = 0

            fakeFile = new gutil.File
                path: './test/fixture/file.js',
                cwd: './test/',
                base: './test/fixture/',
                contents: new Buffer 'sure()'

            stream = etc()

            stream.on 'data', (newFile) ->
                should.exist(newFile)
                should.exist(newFile.path)
                should.exist(newFile.relative)
                should.exist(newFile.contents)
                newFile.path.should.equal './test/fixture/file.js'
                newFile.relative.should.equal 'file.js'
                ++dataCounter


            stream.once 'end', ->
                dataCounter.should.equal 1
                done()

            stream.write fakeFile
            stream.end()

        it 'should pass through two files', (done) ->
            dataCounter = 0

            fakeFile = new gutil.File
                path: './test/fixture/file.js',
                cwd: './test/',
                base: './test/fixture/',
                contents: new Buffer 'yeah()'

            fakeFile2 = new gutil.File
                path: './test/fixture/file2.js',
                cwd: './test/',
                base: './test/fixture/',
                contents: new Buffer 'yeahmetoo()'


            stream = etc()

            stream.on 'data', (newFile) ->
                ++dataCounter

            stream.once 'end', ->
                dataCounter.should.equal 2
                done()

            stream.write fakeFile
            stream.write fakeFile2
            stream.end()

        it 'should use options', (done) ->
            dataCounter = 0

            fakeFile = new gutil.File
                path: './test/fixture/file.js',
                cwd: './test/',
                base: './test/fixture/',
                contents: new Buffer 'yeah();'

            stream = etc({
                msg: 'Another something'
            })

            stream.on 'data', (newFile) ->
                ++dataCounter

            stream.once 'end', ->
                dataCounter.should.equal 1
                done()

            stream.write fakeFile
            stream.end()
        it 'should handle streams', (done) ->
            dataCounter = 0

            fakeFile = new gutil.File
                path: './test/fixture/file.js',
                cwd: './test/',
                base: './test/fixture/',
                contents: new Buffer 'Hello'

            stream = etc()
            stream.on 'data', -> ++dataCounter
            stream.once 'end', -> done()
            stream.write fakeFile
            stream.end()

        describe 'errors', ->
            describe 'are thrown', ->
                it 'if configuration is just wrong', (done) ->
                    try
                        stream = etc({
                            msg: ->
                        })
                    catch e
                        e.plugin.should.equal PLUGIN_NAME
                        e.message.should.equal ERRS.MSG
                        done()
