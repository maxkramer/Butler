module.exports = function(grunt) {

// Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    bower_concat: {
      all: {
        dest: 'lib/butler.js'
      }
    },
    uglify: {
   bower: {
    options: {
      mangle: true,
      compress: true,
      banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
    },
    files: {
      'lib/butler.min.js': 'lib/butler.js'
    }
  }
}
  });

  grunt.loadNpmTasks('grunt-bower-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.registerTask('buildbower', [
    'bower_concat',
    'uglify:bower'
  ]);
};
