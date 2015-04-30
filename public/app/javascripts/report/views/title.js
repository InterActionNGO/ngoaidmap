'use strict';

define([
  'backbone'
], function(Backbone) {

  var TitleView = Backbone.View.extend({

    el: '#titleView',

    events: {
      'keyup textarea': 'onKeyUp',
      'click button': 'focus'
    },

    initialize: function() {
      this.$textarea = this.$el.find('textarea');
      this.autoResizeTextarea();
      this.checkStringWidth();
      Backbone.Events.on('filters:done', this.showFilters, this);
    },

    onKeyUp: function() {
      this.checkStringWidth();
      this.autoResizeTextarea();
    },

    autoResizeTextarea: function() {
      this.$textarea.css('height', 0)
        .height(this.$textarea[0].scrollHeight);
    },

    checkStringWidth: function() {
      var len = this.$textarea.val().length;
      var w = 275;

      if (len === 0 || len < 15) {
        w = 275;
      } else {
        w = '90%';
      }

      this.$textarea.width(w);
    },

    focus: function() {
      this.$textarea.focus();
    }

  });

  return TitleView;

});
