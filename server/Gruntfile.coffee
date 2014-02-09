module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-nodemon'
  grunt.loadNpmTasks 'grunt-mocha-test'

  grunt.initConfig
    nodemon:
      dev:
        options:
          file: 'app/main.coffee'
    mochaTest:
      api:
        options:
          reporter: 'dot'
        src: ['test/api/**/*.coffee']

  grunt.registerTask 'default', 'Launch the server using nodemon', ['nodemon']
