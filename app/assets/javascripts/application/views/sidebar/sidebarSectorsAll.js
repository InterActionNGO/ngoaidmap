'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'application/services/sidebarService',
  'application/abstract/conexion',
  'text!application/templates/sidebar/sidebarSectors.handlebars'
  ], function(jqueryui,Backbone, handlebars, service, conexion, tpl) {

  var SidebarSectors = Backbone.View.extend({

    el: '#sidebar-sectors-all',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.conexion.getSectorsAllData(_.bind(function(response){
        this.response = response;
        this.render();
      },this))


    },

    parseData: function(){
      var sectors = _.sortBy(_.filter(this.response.sectors, function(s){
        return s.count != 0;
      }),'count');
      return { sectors: sectors.reverse(), all: true };
    },

    setUrl: function(param_name, id){
      return (location.search) ? location.href+'&'+param_name+'='+id : location.href+'?'+param_name+'='+id;
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
      this.initCluster();
    },

    initCluster: function(){
      if (this.$el.length === 0) {
        return false;
      }

      var $items = this.$el.find('a'),
        w = this.$el.width(),
        max = $($items[0]).data('value');

      $items.tooltip({
        position: {
          at: 'center+20 top-5',
          my: 'center bottom'
        }
      });

      for (var i = 0, len = $items.length; i < len; i++) {
        var item = $($items[i]);
        var value = item.attr('data-value');
        var itemWidth = (value / max) * (w - 22);

        if (itemWidth - 30 > 0) {
          item.find('.aller').css('width', itemWidth + 'px');
        } else {
          item.find('.aller').css('width', itemWidth + 10 + 'px');
        }
      }
    }
  });

  return SidebarSectors;

});
