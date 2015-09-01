del = require 'del'
gulp = require 'gulp'
coffee = require 'gulp-coffee'
{spawn} = require 'child_process'

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
    spawn 'npm', ['test'], stdio: 'inherit'

# run `gulp-ember-template-compiler-2` for testing purposes
gulp.task 'gulp-ember-template-compiler-2', ->
    emberTemplateCompiler2 = require './index.coffee'
    gulp.src('./{,test/,test/fixtures/}*.coffee')
        .pipe(emberTemplateCompiler2())

# start workflow
gulp.task 'default', ['coffee'], ->
    gulp.watch ['./{,test/,test/fixtures/}*.coffee'], ['test']

# Generated on 2015-09-01 using generator-gulpplugin-coffee 0.1.3
