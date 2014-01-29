path = require 'path'
module.exports = (grunt)->
  process.env.DEBUG = '12306'
  grunt.initConfig
    clean: 
      bin: ["bin", 'src-temp', 'test-temp', 'test-bin']
    concat: 
      prefix_src:
        options:
          banner: "debug = require('debug')('12306')\n"
        files: [
          expand: true # 将来改为在dev下的配置
          # flatten: true
          cwd: 'src'
          src: ['**/*.ls', '!header.ls']
          dest: 'src-temp/'
          ext: '.ls'
        ]
      prefix_test:
        options:
          banner: require('fs').readFileSync('test/header.ls', {encoding: 'utf-8'})
        files: [
          expand: true # 将来改为在dev下的配置
          # flatten: true
          cwd: 'test'
          src: ['**/*.ls', '!header.ls', '!helpers/**/*', '!fixtures/**/*']
          dest: 'test-temp/'
          ext: '.ls'
        ]

    livescript: 
      src: 
        files: [
          expand: true
          flatten: true
          cwd: 'src-temp'
          src: ['**/*.ls']
          dest: 'bin/'
          ext: '.js'
        ]
      test:
        files: [
          expand: true # 将来改为在dev下的配置
          flatten: true
          cwd: 'test-temp'
          src: ['**/*.ls', '!load/**/*', '!helpers/**/*.ls', '!fixtures/**/*.ls']
          dest: 'test-bin/'
          ext: '.spec.js'
        ]
      test_helper:
        options:
          bare: true
        files: [
          expand: true
          flatten: true
          cwd: 'test'
          src: ['helpers/**/*.ls', 'fixtures/**/*.ls']
          dest: 'test-bin/'
          ext: '.js'
        ]
      load:
        files: [
          expand: true # 将来改为在dev下的配置
          flatten: true
          cwd: 'test/load'
          src: ['**/*.ls']
          dest: 'test-bin/load'
          ext: '.js'
        ]

    # express:
    #   my_server:
    #     options:
    #       port: 3010
    #       hostname: 'localhost'
    #       server: path.resolve __dirname, 'bin/server.js'
    #       # bases: 'bin/public/'
    #       # livereload: true
    #       serverreload: true
    #       showStack: true
    simplemocha:
      src: 'test-bin/**/*.spec.js'
      options:
        # require: 'should' # use should in tests without requiring in each
        reporter: 'spec'
        slow: 100
        timeout: 3000
    nodemon:
      app:
        script: 'bin/m-index.js'
        options:
          watch: ['bin']

    watch:
      auto:
        files: ["src/**/*", 'test/**/*']
        # tasks: ["concat", "livescript",  "copy", "simplemocha"]
        tasks: ["clean", "concat", "livescript", "simplemocha"]
        options:
          spawn: true
      manual:
        files: ["src/**/*"]
        tasks: ["concat:prefix_src", "livescript:src"]
        options:
          spawn: true
    concurrent:
      target: 
        tasks:
          ['watch:manual', 'nodemon']
        options:
          logConcurrentOutput: true

      # bp_jade_doc:
      #   files: ["bp/jade-templates/**/*.jade"]
      #   tasks: ["docco:jade"]
      # bp_ls_doc:
      #   files: ["bp/**/*.ls"]
      #   tasks: ["docco:livescript"]


  grunt.loadNpmTasks "grunt-livescript"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-concurrent"
  grunt.loadNpmTasks "grunt-simple-mocha"
  grunt.loadNpmTasks "grunt-nodemon"


  grunt.registerTask "default", ["clean", "concat", "livescript", "simplemocha", "watch:auto"]
  grunt.registerTask "server", ["clean", "concat", "livescript", "concurrent"]
