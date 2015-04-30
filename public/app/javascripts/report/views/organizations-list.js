'use strict';

define([
  'views/class/lists'
], function(ListsView) {

  var OrganizationsListView = ListsView.extend({

    el: '#organizationsListView',

    defaults: {
      slug: 'organizations',
      limit: 30
    }

  });

  return OrganizationsListView;

});
