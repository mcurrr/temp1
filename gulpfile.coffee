gulp = require 'gulp'
plumber = require 'gulp-plumber'
cjsx = require 'gulp-cjsx'
gulpWebpack = require 'gulp-webpack'
webpackConfig = require './webpack.config.js'

gulp.task 'gulpWebpack', ->
	gulp.src './js/cjsx/main.cjsx'
	.pipe(gulpWebpack webpackConfig)
	.pipe(gulp.dest './js/')

gulp.task 'watch', ->
	gulp.watch './js/cjsx/*.cjsx', ['gulpWebpack']

gulp.task 'default', ['watch', 'gulpWebpack']