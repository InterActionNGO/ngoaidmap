'use strict';

define(['backbone', 'liveupdate'], function(Backbone) {

  var FiltersView = Backbone.View.extend({

    el: '#filtersView',

    initialize: function() {
      var self = this;

      this.$categoriesSelector = $('.categories-selector');
      this.$menu = this.$el.find('.menu');

      this.liveUpdate();

      if (Modernizr.touch) {
        this.$el.find('.father').on('touchend', function(ev) {
          var item = $(ev.currentTarget).closest('li');

          item.toggleClass('is-touched');

          if (item.hasClass('is-touched')) {
            item.find('.menu').css('display', 'block');
          } else {
            item.find('.menu').css('display', 'none');
          }
        });
      }

      this.fixCategoriesSelector();

      $(window).on('scroll', function() {
        self.fixCategoriesSelector();
      });
    },

    liveUpdate: function() {
        
      $("#reporting-orgs-menu").find("input.mod-categories-search")
        .liveUpdate('.organizations-child li a');
      $("#all-partners-orgs-menu").find("input.mod-categories-search")
        .liveUpdate('.partners-child li a');
      $("#donor-orgs-menu").find("input.mod-categories-search")
        .liveUpdate('.donors-child li a');

      this.$el.find('.countries input.mod-categories-search')
        .liveUpdate('.countries .mod-categories-child li a');
    },

    fixCategoriesSelector: function() {
      var scrollTop,
      categoriesSelector = this.$categoriesSelector,
      menu = this.$menu;

      var elementOffset = (categoriesSelector.length > 0) ? $('.main-content').offset().top - 49 : 0;

      if (categoriesSelector.length === 0) {
        return false;
      }

      scrollTop = $(window).scrollTop();

      if (scrollTop > elementOffset) {
        categoriesSelector.addClass('is-fixed');

        menu
          .removeClass('mod-go-up-menu')
          .addClass('mod-drop-down-menu');

        $('.layout-sidebar, .layout-content').css({
          marginTop: 50
        });
      } else {
        categoriesSelector.removeClass('is-fixed');

        menu
          .addClass('mod-go-up-menu')
          .removeClass('mod-drop-down-menu');
        $('.layout-sidebar, .layout-content').css({
          marginTop: 0
        });
      }
    }

  });

  return FiltersView;

});
