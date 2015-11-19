'use strict';

define([
  'backbone',
  'handlebars',
  'application/views/sidebar/sidebarOrganizationsClass',
  'text!application/templates/sidebar/sidebarOrganizationsMediaContact.handlebars'
  ], function(Backbone, Handlebars, SidebarOrganizationsClass, tpl) {

  var sidebarOrganizationsMediaContact = SidebarOrganizationsClass.extend({

    el: '#sidebar-organization-mediacontact',

    template: Handlebars.compile(tpl),

    validations: ['media_contact_email', 'media_contact_name', 'media_contact_phone_number', 'media_contact_position'],

    initialize: function(options) {
      SidebarOrganizationsClass.prototype.initialize.apply(this, [options])
    },

    parseData: function(){
      return {
        media_contact_email: (this.organization.media_contact_email) ? this.organization.media_contact_email : '',
        media_contact_name: (this.organization.media_contact_name) ? this.organization.media_contact_name : '',
        media_contact_phone_number: (this.organization.media_contact_phone_number) ? this.organization.media_contact_phone_number : '',
        media_contact_position: (this.organization.media_contact_position) ? this.organization.media_contact_position : '',
      };
    }

  });

  return sidebarOrganizationsMediaContact;

});
