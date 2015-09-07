del = require 'del'
gulp = require 'gulp'
debug = require 'gulp-debug'
coffee = require 'gulp-coffee'
handlebars = require 'gulp-handlebars'
wrap = require 'gulp-wrap'
declare = require 'gulp-declare'
concat = require 'gulp-concat'
path = require 'path'
fs = require 'fs'
{spawn} = require 'child_process'
etc = require './index.coffee'
File = require 'vinyl'

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

# lookup = (paths, cmd) ->
#     for relativePath in paths
#         do ->
#             absPath = "#{path.join relativePath, cmd}"
#             absPath += '.cmd' if process.platform is 'win32'
#             console.log "found '#{absPath}'" if fs.existsSync(absPath)
# lookup process.env.PATH.split(';'), 'npm'

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
    gulp.src('./{,test/,test/fixtures/}*.{hbs,handlebars}')
        .pipe debug()
        .pipe emberHandlebars()
        .pipe gulp.dest('./test/fixtures/compiled')

gulp.task 'try', ->
    gulp.src('./test/fixtures/*.hbs')
        .pipe(gulp.dest('./compiled'))

# start workflow
gulp.task 'default', ['coffee'], ->
    gulp.watch ['./{,test/,test/fixtures/}*.coffee'], ['test']

gulp.task 'templates', ->
  # Load templates from the source/templates/ folder relative to where gulp was executed
  gulp.src '**/*.hbs', cwd: 'test/fixtures'
    # Compile each Handlebars template source file to a template function using Ember's Handlebars
    .pipe etc.compile()
    # Wrap each template function in a call to Ember.Handlebars.template
    .pipe wrap 'Ember.Handlebars.template(<%= contents %>)'
    .pipe declare
      namespace: 'Ember.TEMPLATES'
      noRedeclare: true # Avoid duplicate declarations
      processName: (filePath) ->
        # Allow nesting based on path using gulp-declare's processNameByPath()
        # You can remove this option completely if you aren't using nested folders
        # Drop the source/templates/ folder from the namespace path by removing it from the filePath
        declare.processNameByPath filePath.replace(/test[\\/]fixtures[\\/]/, '')
    # Concatenate down to a single file
    .pipe concat('templates.js')
    # Write the output into the templates folder
    .pipe gulp.dest('test/fixtures/compiled')
