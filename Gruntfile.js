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
                if (!projectConfig.applications[app].scripts) continue;
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
                            'public/components'
                        ],
                        compress: process.env.NODE_ENV === 'production'
                    }
                };
            for (var app in projectConfig.applications) {
                if (!projectConfig.applications[app].styles) continue;
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
            'bootstrap': {
                'files': [
                    {
                        'expand': true,
                        'cwd': 'public/components/bootstrap/dist/fonts',
                        'src': ['**/*'],
                        'dest': 'public/css/fonts'
                    }
                ]
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
