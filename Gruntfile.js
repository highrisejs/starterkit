module.exports = function (grunt) {
    'use strict';
    var browserify = false;
    var less = false;
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-browserify');
    grunt.initConfig({
        browserify: function () {
            var projectConfig = require('./.yo-rc')['generator-domachine'];
            var config = {
                    options: {
                        transform: [
                            'coffeeify'
                        ],
                        require: ['react'],
                        browserifyOptions: { extensions: ['.coffee'] }
                    }
                };
            for (var app in projectConfig.applications) {
                if (!projectConfig.applications[app].scripts) return {};
                browserify = true;
                config[app] = {
                    files: [{
                            cwd: app + '/client',
                            expand: true,
                            src: projectConfig.applications[app].scripts,
                            dest: 'public/js/' + app,
                            ext: '.js',
                            rename: function rename(dest, src) {
                                var path = require('path');
                                return path.join(dest, src.replace(/\//g, '_'));
                            }
                        }]
                };
            }
            return config;
        }(),
        less: function () {
            var projectConfig = require('./.yo-rc')['generator-domachine'];
            var config = {
                    options: {
                        paths: [
                            'styles',
                            'lib',
                            'bower_components'
                        ],
                        compress: process.env.NODE_ENV === 'production'
                    }
                };
            for (var app in projectConfig.applications) {
                if (!projectConfig.applications[app].styles) return {};
                less = true;
                config[app] = {
                    files: [{
                            cwd: app + '/styles',
                            expand: true,
                            src: projectConfig.applications[app].styles,
                            dest: 'public/css/' + app,
                            ext: '.css',
                            rename: function rename(dest, src) {
                                var path = require('path');
                                return path.join(dest, src.replace(/\//g, '_'));
                            }
                        }]
                };
            }
            return config;
        }(),
        watch: function () {
            var projectConfig = require('./.yo-rc')['generator-domachine'];
            var config = {
                    css: {
                        files: ['styles/**/*'],
                        tasks: ['less']
                    }
                };
            for (var app in projectConfig.applications) {
                config[app + 'Css'] = {
                    files: [app + '/styles/**/*'],
                    tasks: ['less:' + app]
                };
            }
            return config;
        }(),
        copy: {
            'jquery': {
                'files': [{
                        'expand': true,
                        'cwd': 'bower_components/jquery/dist',
                        'src': ['**/*'],
                        'dest': 'public/js'
                    }]
            },
            'bootstrap': {
                'files': [
                    {
                        'expand': true,
                        'cwd': 'bower_components/bootstrap/dist/fonts',
                        'src': ['**/*'],
                        'dest': 'public/css/fonts'
                    },
                    {
                        'expand': true,
                        'cwd': 'bower_components/bootstrap/dist/js',
                        'src': ['**/*'],
                        'dest': 'public/js'
                    }
                ]
            },
            'fontAwesome': {
                'files': [{
                        'expand': true,
                        'cwd': 'bower_components/font-awesome',
                        'src': ['css/**/*', 'fonts/**/*'],
                        'dest': 'public/font-awesome'
                    }]
            },
            'pace': {
                'files': [{
                        'expand': true,
                        'cwd': 'bower_components/pace',
                        'src': [
                          'pace.min.js',
                          'themes/*.css'
                        ],
                        'dest': 'public/pace'
                    }]
            }
        }
    });
    var buildTask = [
        'copy'
    ];
    if (browserify) buildTask.push('browserify');
    if (less) buildTask.push('less');
    grunt.registerTask('build', buildTask);
};
