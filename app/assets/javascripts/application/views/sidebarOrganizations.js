'use strict';

define([
  'backbone',
  'handlebars',
  'text!templates/sidebarOrganizations.handlebars'
  ], function(Backbone, handlebars, tpl) {

  var SidebarOrganizations = Backbone.View.extend({

    el: '#sidebar-organizations',

    template: Handlebars.compile(tpl),

    initialize: function() {
      this.data = map_data;
      this.render();
    },

    parseData: function(){
      var projects = this.data.data;
      var included = this.data.included;

      var organizations = _.groupBy(_.flatten(_.map(projects, function(project){return project.links.organization.linkage})), function(organization){
        return organization.id;
      });

      var organizationsByProjects = _.sortBy(_.map(organizations, function(organization, organizationKey){
        var organizationF = _.findWhere(included, {id: organizationKey, type:'organizations'});
        return{
          name: organizationF.name,
          id: organizationF.id,
          url: '/organizations/'+organizationF.id,
          class: organizationF.name.toLowerCase().replace(/\s/g, "-"),
          count: organization.length
        }
      }), function(organization){
        return -organization.count;
      });

      return { organizations: organizationsByProjects.slice(0, 9) };
    },

    render: function(){
      this.$el.html(this.template(this.parseData()));
    },

  });

  return SidebarOrganizations;

});
