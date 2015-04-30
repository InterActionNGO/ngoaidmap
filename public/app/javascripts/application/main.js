'use strict';

require.config({

  baseUrl: '/app/javascripts/application',

  paths: {
    jquery: '../../vendor/jquery/dist/jquery',
    underscore: '../../vendor/underscore/underscore',
    underscoreString: '../../vendor/underscore.string/lib/underscore.string',
    backbone: '../../vendor/backbone/backbone',
    quicksilver: '../../lib/liveupdate/quicksilver',
    liveupdate: '../../lib/liveupdate/jquery.liveupdate',
    jqueryui: '../../lib/jquery-ui/js/jquery-ui-1.10.4.custom',
    select2: '../../vendor/select2/select2',
    chachiSlider: '../../vendor/chachi-slider/jquery.chachi-slider'
  },

  shim: {
    jquery: {
      exports: '$'
    },
    underscore: {
      exports: '_'
    },
    underscoreString: {
      deps: ['underscore'],
      exports: '_.str'
    },
    backbone: {
      deps: ['jquery', 'underscore'],
      exports: 'Backbone'
    },
    liveupdate: {
      deps: ['jquery', 'quicksilver'],
      exports: '$'
    },
    jqueryui: {
      deps: ['jquery'],
      exports: '$'
    },
    select2: {
      deps: ['jquery'],
      exports: '$'
    },
    chachiSlider: {
      deps: ['jquery'],
      exports: '$'
    }
  }

});

require([
  'jquery',
  'router',
  'chachiSlider'
], function($, Router) {

  // Extensions
  Number.prototype.toCommas = function() {
    return this.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  };

  $.fn.noHandleChildren = function() {

    var SearchMenu = function(el) {
      var $el = $(el),
        menuChildren = $el.find('.submenu li').length;

      if (menuChildren === 0) {
        $el.addClass('no-child');
      }
    };

    return this.each(function(index, el) {
      new SearchMenu(el);
    });
  };

  function sectionTitle() {
    var $title = $('.mod-content-article').find('h1');

    if ($title.text().length > 50) {
      $title.css('font-size', '36px');
    }
  }

  function addClassToBody() {
    var newClass, position;

    position = window.location.pathname.split('/').length - 1;
    newClass = window.location.pathname.split('/')[position];

    $('body').addClass('linos-' + newClass);
  }

  function goTo(e) {
    $('body, html').animate({
      scrollTop: $('.main-content').offset().top - 49
    }, 500);
    e.preventDefault();
  }

  $('.btn-go-to-projects').on('click', goTo);

  sectionTitle();
  addClassToBody();
  $('.menu-item').noHandleChildren();

  var $projectBudget = $('#projectBudgetValue');

  if ($projectBudget.text().length > 8) {
    $projectBudget.css({
      'font-size': '35px'
    });
  }

  $('.mod-logos-slider').chachiSlider({
    navigation: false,
    pauseTime: 7000
  });

  // $('#feedbackBtn').on('click', function(e) {
  //   e.preventDefault();
  //   $('#feedbackOverlay').show();
  // });

  new Router();

});
