'use strict';

define([
  'report/views/class/lists'
], function(ListsView) {

  var ProjectsListView = ListsView.extend({

    el: '#projectsListView',

    defaults: {
      slug: 'projects',
      limit: 30
    }

  });

  return ProjectsListView;

});
