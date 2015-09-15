'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'application/abstract/conexion',
  'text!application/templates/sidebar/sidebarSectors.handlebars'
  ], function(jqueryui,Backbone, handlebars, conexion, tpl) {

  var SidebarSectors = Backbone.View.extend({

    el: '#sidebar-sectors',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.conexion = conexion;
      this.filters = this.conexion.getFilters();
      this.render();

    },

    parseData: function(){
      var sectorsByProjects = this.conexion.getSectorsByProjects(!!this.$el.data('nofilter'));
      if (sectorsByProjects.length == 1 && !!this.filters['sectors[]']) {
        this.$el.remove();
        return
      }

      return { sectors: sectorsByProjects };
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
