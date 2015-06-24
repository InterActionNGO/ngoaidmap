'use strict';

define([
  'jqueryui',
  'backbone',
  'handlebars',
  'services/sidebarService',
  'text!templates/sidebar/sidebarDonors.handlebars'
  ], function(jqueryui,Backbone, handlebars, service, tpl) {

  var SidebarDonors = Backbone.View.extend({

    el: '#sidebar-donors',

    template: Handlebars.compile(tpl),

    initialize: function() {
      if (!this.$el.length) {
        return
      }

      service.execute('donors-by-sector', _.bind(this.successSidebar, this ), _.bind(this.errorSidebar, this ));
    },

    successSidebar: function(data){
      console.log(data);
      this.data = data.data;
      this.render();
    },

    errorSidebar: function(){
      this.$el.remove();
    },

    parseData: function(){
      // var projects = this.data.data;
      // var included = this.data.included;

      // var donors = _.groupBy(_.flatten(_.map(projects, function(project){return project.links.donors.linkage})), function(donor){
      //   return donor.id;
      // });

      return { donors: this.data };
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },


  });

  return SidebarDonors;

});
