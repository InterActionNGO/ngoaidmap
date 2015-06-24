'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'text!templates/sidebar/sidebarDonors.handlebars'
  ], function(jqueryui,Backbone, handlebars, tpl) {

  var SidebarDonors = Backbone.View.extend({

    el: '#sidebar-donors',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }
      this.data = map_data;
      this.render();
    },

    parseData: function(){
      // var projects = this.data.data;
      // var included = this.data.included;

      // var donors = _.groupBy(_.flatten(_.map(projects, function(project){return project.links.donors.linkage})), function(donor){
      //   return donor.id;
      // });

      // return { donors: donors };
    },

    render: function(){
      // this.$el.html(this.template(this.parseData()));
      this.$el.remove();
    },


  });

  return SidebarDonors;

});
