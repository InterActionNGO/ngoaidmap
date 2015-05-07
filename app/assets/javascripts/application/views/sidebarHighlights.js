'use strict';

define([
  'backbone',
  'handlebars',
  'text!templates/sidebarHighlights.handlebars'
  ], function(Backbone, handlebars, tpl) {

  var SidebarHighlights = Backbone.View.extend({

    el: '#sidebar-highlights',

    template: Handlebars.compile(tpl),

    initialize: function() {
      this.data = map_data;
      this.render();
    },

    parseData: function(){
      return {
        projectsLength: this.data.data.length.toLocaleString(),
        organizationsLength: _.filter(this.data.included, function(include){ return include.type == 'organizations' }).length.toLocaleString()
      }
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    }

  });

  return SidebarHighlights;

});
