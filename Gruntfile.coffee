path = require 'path'
module.exports = (grunt)->
  # process.env.DEBUG = 'aw'
  grunt.initConfig
    clean: 
      bin: ['bin']

    livescript: 
      main: 
        files: [
          expand: true
          cwd: 'src'
          src: ['**/*.ls']
          dest: 'bin/'
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
    nodemon:
      app:
        script: 'bin/index.js'
        options:
          watch: ['bin']

    watch:
      app:
        files: ["src/**/*.ls"]
        # tasks: ["concat", "livescript",  "copy", "simplemocha"]
        tasks: ["clean", "livescript"]
        options:
          spawn: true
    concurrent:
      target: 
        tasks:
          ['watch', 'nodemon']
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
  grunt.loadNpmTasks "grunt-concurrent"
  grunt.loadNpmTasks "grunt-nodemon"


  grunt.registerTask "default", ["clean", "livescript", "concurrent"]
