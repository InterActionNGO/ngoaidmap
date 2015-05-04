'use strict';

define(['backbone'], function(Backbone) {

  var MenuFixedView = Backbone.View.extend({

    el: '#menuFixedView',

    events: {
      'click li a': 'onClick'
    },

    initialize: function() {
      var self = this;

      if (this.$el.length === 0) {
        return false;
      }

      var h = $('.mod-header').height() + $('.mod-hero').height();
      var maxh = $('.mod-featured-projects').offset().top - this.$el.height() - 130;
      var t = $('.layout-content').height() - this.$el.height();

      this.$page = $('html, body');

      $(window).on('scroll', function(e) {
        if (e.currentTarget.pageYOffset > h) {
          self.$el.addClass('is-fixed');
        } else {
          self.$el.removeClass('is-fixed');
        }

        if (e.currentTarget.pageYOffset > maxh) {
          self.$el.addClass('is-bottom-fixed').css('top', t + 'px');
        } else {
          self.$el.removeClass('is-bottom-fixed').css('top', '60px');
        }
      });
    },

    onClick: function(e) {
      var target = $(e.currentTarget).attr('href').split('#')[1];
      var y = $('#' + target).offset().top;

      this.$page.animate({
        scrollTop: y
      }, 500);

      e.preventDefault();
    }

  });

  return MenuFixedView;

});
