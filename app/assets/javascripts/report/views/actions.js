'use strict';

define([
  'underscore',
  'backbone',
  'report/models/report'
], function(_,Backbone, ReportModel) {

  var ActionsView = Backbone.View.extend({

    el: '#actionsView',

    events: {
      'click #printReport': 'print',
      'click #download': 'download'
    },

    initialize: function() {
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this.show, this);
      Backbone.Events.on('filters:done', this.download, this);
      this.$print = $("#printReport");
      this.$download = $("#download");
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    },

    show: function() {
      this.$el.removeClass('is-hidden');
    },

    print: function() {
      window.print();
    },
    
    download: function () {
        var ids = _.pluck(ReportModel.instance.get('projects'), 'id');
        $.ajax({
            url: 'data/download',
            method: 'post',
            data: { ids: ids },
            context: this
        }, this)
        .success(function (data) {
            var encoded = 'data:application/csv;charset=utf-8,'+encodeURIComponent(data);
            this.$download.attr({'href': encoded});
        }, this)
        .fail(function (x) { console.log(x); });
    }
    

  });

  return ActionsView;

});
