'use strict';

define([
  'jquery',
  'backbone',
  'handlebars',
  'text!application/templates/titles/titleSector.handlebars'
  ], function(jquery, Backbone, handlebars, tpl) {

  var TitleSector = Backbone.View.extend({

    el: '#title-sector',

    template: Handlebars.compile(tpl),

    initialize: function(options) {
      if (!this.$el.length) {
        return
      }
      this.conexion = options.conexion;
      this.params = this.conexion.getParams();
      this.filters = this.conexion.getFilters();
      this.conexion.getTitleData(_.bind(function(data){
        this.data = _.reduce(_.compact(_.map(data, function(m){return (!!m) ? m[0]: null;})), function(memo, num){
          return _.extend({}, memo, num);
        }, {});
        this.render();
      },this))
    },

    parseData: function(){
      return {
        name: this.projectString(),
        country: this.countryString()
      }
    },

    projectString: function(){
      var projects = (this.data.projects_count > 1) ? 'projects' : 'project';
      var sector = (!!this.data.sector) ? this.data.sector.name : '';
      var count = this.data.projects_count.toLocaleString();
      return count +' '+sector+' '+projects;
    },

    countryString: function(count){
      return (!!this.data.geolocation) ? this.data.geolocation.name : this.data.countries_count + ' countries';
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },


  });

  return TitleSector;

});
