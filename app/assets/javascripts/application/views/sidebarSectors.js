'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'text!templates/sidebarSectors.handlebars'
  ], function(jqueryui,Backbone, handlebars, tpl) {

  var SidebarSectors = Backbone.View.extend({

    el: '#sidebar-sectors',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.data = map_data;
      this.render();
    },

    parseData: function(){
      var projects = this.data.data;
      var included = this.data.included;

      var sectors = _.groupBy(_.flatten(_.map(projects, function(project){return project.links.sectors.linkage})), function(sector){
        return sector.id;
      });

      var sectorsByProjects = _.sortBy(_.map(sectors, function(sector, sectorKey){
        var sectorF = _.findWhere(included, {id: sectorKey, type:'sectors'});
        return{
          name: sectorF.name,
          id: sectorF.id,
          url: '/sectors/'+sectorF.id,
          class: sectorF.name.toLowerCase().replace(/\s/g, "-"),
          count: sector.length
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
