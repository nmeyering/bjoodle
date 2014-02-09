module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-nodemon'

  grunt.initConfig
    nodemon:
      dev:
        options:
          file: 'server.coffee'

  grunt.registerTask 'default', 'Launch the server using nodemon', ['nodemon']
