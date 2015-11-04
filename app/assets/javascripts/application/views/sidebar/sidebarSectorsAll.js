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

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      service.execute('sectors-all', _.bind(this.successSidebar, this ), _.bind(this.errorSidebar, this ));

    },

    successSidebar: function(data){
      this.data = data.data;
      this.render();
    },

    errorSidebar: function(){
      this.$el.remove();
    },

    parseData: function(){
      var sectorsByProjects = this.conexion.getSectorsByProjectsAll(this.data,sector.id);
      if (!!sectorsByProjects.length) {
        return { sectors: sectorsByProjects, all: true };
      } else {
        this.$el.remove();
      }
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
