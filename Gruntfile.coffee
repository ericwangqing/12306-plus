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
    watch:
      app:
        files: ["src/**/*.ls"]
        # tasks: ["concat", "livescript",  "copy", "simplemocha"]
        tasks: ["clean", "livescript"]
        options:
          spawn: true
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

  grunt.registerTask "default", ["clean", "livescript", "watch"]
