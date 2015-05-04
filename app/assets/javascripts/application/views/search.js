'use strict';

define(['backbone', 'select2'], function(Backbone) {

  var SearchView = Backbone.View.extend({

    el: '#searchSidebarView',

    initialize: function() {
      if (this.$el.length === 0) {
        return false;
      }

      this.$el.find('select').select2({
        width: 'element'
      });
    },

    onChange: function() {
      this.$el.find('form').submit();
    }

  });

  return SearchView;

});
