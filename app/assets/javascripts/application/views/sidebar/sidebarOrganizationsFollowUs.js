'use strict';

define([
  'backbone',
  'handlebars',
  'application/views/sidebar/sidebarOrganizationsClass',
  'text!application/templates/sidebar/sidebarOrganizationsFollowUs.handlebars'
  ], function(Backbone, Handlebars, SidebarOrganizationsClass, tpl) {

  var sidebarOrganizationsFollowUs = SidebarOrganizationsClass.extend({

    el: '#sidebar-organization-followus',

    template: Handlebars.compile(tpl),

    validations: ['logo_file_name', 'website', 'twitter', 'facebook', 'contact_email'],

    initialize: function(options) {
      SidebarOrganizationsClass.prototype.initialize.apply(this,[options]);
    },

    parseData: function(){
      var sozial = (this.organization.twitter || this.organization.facebook || this.organization.contact_email);
      return {
        id: this.organization.id,
        logo: (this.organization.logo_file_name) ? this.organization.logo_file_name : '',
        website: (this.organization.website) ? this.organization.website : '',
        twitter: (this.organization.twitter) ? this.organization.twitter : '',
        facebook: (this.organization.facebook) ? this.organization.facebook : '',
        contact_email: (this.organization.contact_email) ? this.organization.contact_email : '',
        sozial: sozial
      };
    },
  });

  return sidebarOrganizationsFollowUs;

});
