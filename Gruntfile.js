'use strict';

module.exports = function(grunt) {

  require('load-grunt-tasks')(grunt);
  require('time-grunt')(grunt);

  grunt.initConfig({

    root: {
      app: 'public/app',
      tmp: 'public/.tmp',
      dist: 'public/dist'
    },

    clean: {
      all: [
        '<%= root.tmp %>',
        '<%= root.dist %>'
      ]
    },

    jshint: {
      options: {
        jshintrc: '.jshintrc',
        reporter: require('jshint-stylish')
      },
      all: [
        'Gruntfile.js',
        '<%= root.app %>/javascripts/{,*/}{,*/}{,*/}*.js',
        '!<%= root.app %>/javascripts/backoffice/{,*/}{,*/}*.js'
      ]
    },

    uglify: {
      options: {
        mangle: false
      },
      dist: {
        files: {
          '<%= root.dist %>/vendor/requirejs/require.js': [
            '<%= root.app %>/vendor/requirejs/require.js'
          ],
          '<%= root.dist %>/lib/modernizr/modernizr.custom.js': [
            '<%= root.app %>/lib/modernizr/modernizr.custom.js'
          ]
        }
      }
    },

    copy: {
      app: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= root.app %>',
          dest: '<%= root.tmp %>',
          src: [
            'stylesheets/backoffice/**/*'
          ]
        }]
      },
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= root.app %>',
          dest: '<%= root.dist %>',
          src: [
            'fonts/**/*',
            'images/**/*',
            'stylesheets/backoffice/**/*',
            'javascripts/backoffice/**/*'
          ]
        }]
      }
    },

    compass: {
      options: {
        sassDir: '<%= root.app %>/stylesheets',
        cssDir: '<%= root.tmp %>/stylesheets',
        generatedImagesDir: '<%= root.tmp %>/images/sprite',
        fontsDir: '<%= root.app %>/fonts',
        imagesDir: '<%= root.app %>/images',
        relativeAssets: true
      },
      dist: {
        options: {
          generatedImagesDir: '<%= root.dist %>/images/sprite',
          httpStylesheetsPath: '/dist/stylesheets',
          httpImagesPath: '/dist/images',
          httpGeneratedImagesPath: '/dist/images/sprite',
          httpFontsPath: '/dist/fonts',
          relativeAssets: false,
          environment: 'production'
        }
      },
      app: {
        options: {
          debugInfo: true,
          environment: 'development'
        }
      }
    },

    cssmin: {
      main: {
        files: {
          '<%= root.dist %>/stylesheets/main.css': [
            '<%= root.app %>/lib/jquery-ui/css/no-theme/jquery-ui-1.10.4.custom.css',
            '<%= root.app %>/vendor/chachi-slider/chachi-slider.css',
            '<%= root.app %>/vendor/select2/select2.css',
            '<%= root.tmp %>/stylesheets/main.css'
          ]
        }
      },
      report: {
        files: {
          '<%= root.dist %>/stylesheets/report.css': [
            '<%= root.app %>/lib/jquery-ui/css/no-theme/jquery-ui-1.10.4.custom.css',
            '<%= root.app %>/vendor/select2/select2.css',
            '<%= root.app %>/vendor/leaflet.markercluster/dist/MarkerCluster.css',
            '<%= root.tmp %>/stylesheets/report.css'
          ]
        }
      },
      embed: {
        files: {
          '<%= root.dist %>/stylesheets/embed.css': [
            '<%= root.tmp %>/stylesheets/embed.css'
          ]
        }
      },
      countdown: {
        files: {
          '<%= root.dist %>/stylesheets/countdown.css': [
            '<%= root.tmp %>/stylesheets/countdown.css'
          ]
        }
      },
      backoffice: {
        files: {
          '<%= root.dist %>/stylesheets/backoffice.css': [
            '<%= root.tmp %>/stylesheets/backoffice.css'
          ]
        }
      }
    },

    imagemin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= root.app %>/images',
          src: '{,*/}*{,*/}*{,*/}*.{png,jpg,jpeg,gif}',
          dest: '<%= root.dist %>/images'
        }]
      },
      libs: {
        files: {
          '<%= root.dist %>/stylesheets/select2.png': '<%= root.app %>/vendor/select2/select2.png',
          '<%= root.dist %>/stylesheets/select2-spinner.gif': '<%= root.app %>/vendor/select2/select2-spinner.gif'
        }
      }
    },

    svgmin: {
      options: {
        plugins: [{
          removeViewBox: false
        }, {
          removeUselessStrokeAndFill: false
        }]
      },
      dist: {
        files: [{
          expand: true,
          cwd: '<%= root.app %>/images',
          src: '{,*/}*{,*/}*{,*/}*.svg',
          dest: '<%= root.dist %>/images'
        }]
      }
    },

    requirejs: {
      options: {
        optimize: 'uglify',
        preserveLicenseComments: false,
        useStrict: true,
        wrap: false
      },
      application: {
        options: {
          baseUrl: '<%= root.app %>/javascripts/application',
          include: 'main',
          out: '<%= root.dist %>/javascripts/application/main.js',
          mainConfigFile: '<%= root.app %>/javascripts/application/main.js',
        }
      },
      report: {
        options: {
          baseUrl: '<%= root.app %>/javascripts/report',
          include: 'main',
          out: '<%= root.dist %>/javascripts/report/main.js',
          mainConfigFile: '<%= root.app %>/javascripts/report/main.js',
        }
      },
      countdown: {
        options: {
          baseUrl: '<%= root.app %>/javascripts/countdown',
          include: 'main',
          out: '<%= root.dist %>/javascripts/countdown/main.js',
          mainConfigFile: '<%= root.app %>/javascripts/countdown/main.js',
        }
      }
    },

    watch: {
      options: {
        nospawn: true
      },
      styles: {
        files: [
          '<%= root.app %>/stylesheets/{,*/}*{,*/}*.{scss,sass}',
          '<%= root.app %>/images/{,*/}*{,*/}*.{png,jpg}'
        ],
        tasks: ['compass:app']
      },
      scripts: {
        files: '<%= jshint.all %>',
        tasks: ['jshint']
      }
    }

  });

  grunt.registerTask('default', [
    'clean',
    'jshint',
    'copy:app',
    'compass:app'
  ]);

  grunt.registerTask('build', [
    'clean',
    'jshint',
    'uglify',
    'copy:dist',
    'imagemin',
    'svgmin',
    'compass:dist',
    'cssmin',
    'requirejs'
  ]);

};
