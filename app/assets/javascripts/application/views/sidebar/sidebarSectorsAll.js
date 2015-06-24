'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'services/sidebarService',
  'text!templates/sidebar/sidebarSectors.handlebars'
  ], function(jqueryui,Backbone, handlebars, service, tpl) {

  var SidebarSectors = Backbone.View.extend({

    el: '#sidebar-sectors-all',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }

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
      var sectorsByProjects = _.sortBy(_.map(this.data, function(v){
        return {
          name: v.name,
          id: v.id,
          url: '/sectors/'+v.id,
          class: v.name.toLowerCase().replace(/\s/g, "-"),
          count: v.projects_count
        }
      }), function(sector){
        return -sector.count;
      });
      return { sectors: sectorsByProjects };
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
