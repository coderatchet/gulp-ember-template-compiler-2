# gulp-ember-template-compiler-2 [![NPM version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url] [![Coverage Status][coveralls-image]][coveralls-url] [![Dependency Status][depstat-image]][depstat-url] [![devDependency Status][devdepstat-image]][devdepstat-url]


> Ember-template-compiler-2 plugin for [gulp](http://gulpjs.com/) 3.

## Usage

First, install `gulp-ember-template-compiler-2` as a development dependency:

```shell
npm install --save-dev gulp-ember-template-compiler-2
```

Then, add it to your `gulpfile.js`:

```javascript
var gulp = require('gulp');
var ember-template-compiler-2 = require('gulp-ember-template-compiler-2');

gulp.task('default', function () {
    gulp.src('./src/*.ext')
        .pipe(ember-template-compiler-2({msg: 'More Coffee!'}))
        .pipe(gulp.dest("./dist"));
});
```

## API `ember-template-compiler-2(opt)`

## opt.msg
Type: `String`
Default: `More Coffee!`

The message you wish to attach to file.


## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License) © [Jared](http://thenaglecode.com)

[npm-url]: https://npmjs.org/package/gulp-ember-template-compiler-2
[npm-image]: https://img.shields.io/npm/v/gulp-ember-template-compiler-2.svg

[travis-url]: http://travis-ci.org/coderatchet/gulp-ember-template-compiler-2
[travis-image]: https://secure.travis-ci.org/coderatchet/gulp-ember-template-compiler-2.svg?branch=master

[coveralls-url]: https://coveralls.io/r/coderatchet/gulp-ember-template-compiler-2
[coveralls-image]: https://img.shields.io/coveralls/coderatchet/gulp-ember-template-compiler-2.svg

[depstat-url]: https://david-dm.org/coderatchet/gulp-ember-template-compiler-2
[depstat-image]: https://david-dm.org/coderatchet/gulp-ember-template-compiler-2.svg

[devdepstat-url]: https://david-dm.org/coderatchet/gulp-ember-template-compiler-2#info=devDependencies
[devdepstat-image]: https://david-dm.org/coderatchet/gulp-ember-template-compiler-2/dev-status.svg
