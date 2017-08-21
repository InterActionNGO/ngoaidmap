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
      this.$downloadLink = $("#download");
      this.autoResizeTextarea();
      this.checkStringWidth();
      Backbone.Events.on('filters:done', this.showFilters, this);
    },

    onKeyUp: function() {
      this.checkStringWidth();
      this.autoResizeTextarea();
      this.updateDownloadFilename();
    },

    autoResizeTextarea: function() {
      this.$textarea.css('height', 0)
        .height(this.$textarea[0].scrollHeight);
    },

    checkStringWidth: function() {
      var len = this.$textarea.val().length;
      var w = 295;

      if (len === 0 || len < 15) {
        w = 295;
      } else {
        w = '90%';
      }

      this.$textarea.width(w);
    },

    focus: function() {
      this.$textarea.focus();
    },
    
    updateDownloadFilename: function () {
        this.$downloadLink.attr('download', this.$textarea.val()+'.csv');
    }

  });

  return TitleView;

});
