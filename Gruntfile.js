module.exports = function(grunt) {
  grunt.initConfig({
    coffee: {
      compile: {
        files: {
          'js/main.js': 'src/*.coffee'
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-coffee');
};
