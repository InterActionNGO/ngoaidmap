'use strict';

define(['backbone'], function(Backbone) {

  var FilterSummaryView = Backbone.View.extend({

    el: '#filter_summary',

    events: {
      'mouseenter .close-x': 'fade',
      'mouseleave .close-x': 'restore'
    },

    fade: function(e) { 
      $(e.target).parents('.project-filter-list-item').addClass('faded');
      e.preventDefault();
    },
    
    restore: function (e) {
      $(e.target).parents('.project-filter-list-item').removeClass('faded');
      e.preventDefault();
    }

  });

  return FilterSummaryView;

});