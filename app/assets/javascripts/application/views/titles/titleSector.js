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
        this.data = _.reduce(_.map(data, function(m){return m[0];}), function(memo, num){
          return _.extend({}, memo, num);
        }, {});
        this.render();
      },this))
    },

    parseData: function(){
      console.log(this.data);
      return {
        name: this.projectString(),
        country: this.countryString()
      }
      // this.countries = this.conexion.getCountries();
      // this.donors = this.conexion.getDonors();

      // var countP = this.conexion.getProjects().length;
      // var countC = this.countries.length;
      // var donorsC = this.donors.length;
      // var projects = this.projectString(countP,donorsC);
      // var countries = this.countryString(countC);

      // return {
      //   name: projects,
      //   country: countries
      // }
    },

    projectString: function(count, donorCount){
      // var donor = (donorCount == 1 && !!this.filters['donors[]']) ? _.unescape(this.donors[0].name) : '';
      // if (count == 1) {
      //   if (!!donor) {
      //     return count.toLocaleString() +' '+this.$el.data('name')+' project donated by ' + donor;
      //   }
      //   return count.toLocaleString() +' '+this.$el.data('name')+' project';
      // }else{
      //   if (!!donor) {
      //     return count.toLocaleString() +' '+this.$el.data('name')+' projects donated by ' + donor;
      //   }
      //   return count.toLocaleString() +' '+this.$el.data('name')+' projects';
      // }
    },

    countryString: function(){
      var count = this.data.countries_count;
      if (count == 1 && !!this.filters['geolocation']) {
        console.log(this.filters['geolocation']);
        // return this.countries[0].name
        return count.toLocaleString() +' countries'
      }else{
        return count.toLocaleString() +' countries'
      }
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },


  });

  return TitleSector;

});
