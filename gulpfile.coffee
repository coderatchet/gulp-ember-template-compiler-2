del = require 'del'
gulp = require 'gulp'
debug = require 'gulp-debug'
coffee = require 'gulp-coffee'
path = require 'path'
fs = require 'fs'
{spawn} = require 'child_process'

# call spawn with logging to debug ENOENT problems
# spawn = (->
#     {spawn} = require("child_process")
#     oldSpawn = spawn
#     mySpawn = ->
#         console.log 'spawn called'
#         console.log arguments
#         oldSpawn.apply this, arguments
#     mySpawn
# )()

lookup = (paths, cmd) ->
    for relativePath in paths
        do ->
            absPath = "#{path.join relativePath, cmd}"
            absPath += '.cmd' if process.platform is 'win32'
            console.log "found '#{absPath}'" if fs.existsSync(absPath)
lookup process.env.PATH.split(';'), 'npm'

# compile `index.coffee`
gulp.task 'coffee', ->
    gulp.src('index.coffee')
        .pipe(coffee bare: true)
        .pipe(gulp.dest './')

# remove `index.js` and `coverage` dir
gulp.task 'clean', (cb) ->
    del ['index.js', 'coverage'], cb

# run tests
gulp.task 'test', ['coffee'], ->
    spawn 'npm.cmd', ['test'],
        stdio: 'inherit'
    .on 'error', (msg) -> console.log msg

# run `gulp-ember-template-compiler-2` for testing purposes
gulp.task 'gulp-ember-template-compiler-2', ->
    emberTemplateCompiler2 = require './index.coffee'
    gulp.src('./{,test/,test/fixtures/}*.{hbs,handlebars}')
        .pipe debug()
        .pipe emberTemplateCompiler2()
        .pipe gulp.dest('./test/fixtures/compiled')

# start workflow
gulp.task 'default', ['coffee'], ->
    gulp.watch ['./{,test/,test/fixtures/}*.coffee'], ['test']

# Generated on 2015-09-01 using generator-gulpplugin-coffee 0.1.3
