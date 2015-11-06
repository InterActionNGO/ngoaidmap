'use strict';

define([
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/sidebar/sidebarHighlights.handlebars'
  ], function(Backbone, handlebars, conexion, tpl) {

  var SidebarHighlights = Backbone.View.extend({

    el: '#sidebar-highlights',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.filters = this.$el.data('highlights');

      this.conexion.getHighlightsData(_.bind(function(data){
        this.data = _.reduce(_.map(data, function(m){return m[0];}), function(memo, num){
          return _.extend({}, memo, num);
        }, {});
        this.render();
      }, this ));
    },

    parseData: function(){
      return _.each(this.data, _.bind(function(v,k) {
        if(!_.contains(this.filters, k)) {
          delete this.data[k];
        }
      }, this ))
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    }

  });

  return SidebarHighlights;

});
