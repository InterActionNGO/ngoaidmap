'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/sidebar/sidebarSectors.handlebars'
  ], function(jqueryui,Backbone, Handlebars, conexion, tpl) {

  var SidebarSectors = Backbone.View.extend({

    el: '#sidebar-sectors',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.params = this.conexion.getParams();
      this.filters = this.conexion.getFilters();
      this.conexion.getSectorsData(_.bind(function(response){
        this.response = response.sectors;
        if (!!this.filters && !this.filters['sectors[]'] && !!this.response.length) {
          this.render();
        } else {
          this.$el.remove();
        }
      },this))
    },

    parseData: function(){
      var sectors = _.sortBy(_.filter(this.response, function(s){
        return s.count != 0;
      }),'count');
      return { sectors: sectors.reverse(), filtered: !!this.params.name };
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
