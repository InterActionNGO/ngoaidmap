'use strict';

require.config({

  baseUrl: '/app/javascripts/report',

  paths: {
    jquery: '../../vendor/jquery/dist/jquery',
    jqueryui: '../../lib/jquery-ui/js/jquery-ui-1.10.4.custom',
    underscore: '../../vendor/underscore/underscore',
    underscoreString: '../../vendor/underscore.string/lib/underscore.string',
    backbone: '../../vendor/backbone/backbone',
    select2: '../../vendor/select2/select2',
    handlebars: '../../vendor/handlebars/handlebars',
    highcharts: '../../vendor/highcharts-release/highcharts',
    spin: '../../vendor/spinjs/spin',
    moment: '../../vendor/moment/moment',
    momentRange: '../../vendor/moment-range/lib/moment-range.bare',
    markerCluster: '../../vendor/leaflet.markercluster/dist/leaflet.markercluster',
    text: '../../vendor/requirejs-text/text'
  },

  shim: {
    jquery: {
      exports: '$'
    },
    jqueryui: {
      deps: ['jquery'],
      exports: '$'
    },
    underscore: {
      exports: '_'
    },
    underscoreString: {
      deps: ['underscore'],
      exports: '_.str'
    },
    backbone: {
      deps: ['jquery', 'underscore'],
      exports: 'Backbone'
    },
    sprintf: {
      exports: 'sprintf'
    },
    select2: {
      deps: ['jquery'],
      exports: '$'
    },
    form: {
      deps: ['jquery'],
      exports: '$'
    },
    handlebars: {
      exports: 'Handlebars'
    },
    highcharts: {
      deps: ['jquery'],
      exports: 'Highcharts'
    },
    momentRange: {
      deps: ['moment'],
      exports: 'momentRange'
    }
  }

});

require([
  'underscore',
  'underscoreString',
  'handlebars',
  'highcharts',

  'views/spin',
  'views/filters-form',
  'views/intro',
  'views/title',
  'views/filters',
  'views/summary',
  'views/budgets',
  'views/timeline-charts',
  'views/actions',
  'views/limitations',

  'views/donors-snapshot',
  'views/organizations-snapshot',
  'views/countries-snapshot',
  'views/sectors-snapshot',

  'views/donors-list',
  'views/organizations-list',
  'views/projects-list',
  'views/countries-list',
  'views/sectors-list'
], function(
  _, underscoreString, Handlebars, Highcharts,
  SpinView, FiltersFormView, IntroView,
  TitleView, FiltersView, SummaryView, BudgetsView, TimelineChartsView, ActionsView, LimitationsView,
  DonorsSnapshotView, OrganizationsSnapshotView, CountriesSnapshotView, SectorsSnapshotView,
  DonorsListView, OrganizationsListView, ProjectsListView, CountriesListView, SectorsListView
) {

  // Extensions
  Number.prototype.toCommas = function() {
    return _.str.numberFormat(this, 0);
  };

  // Handlebars
  Handlebars.registerHelper('commas', function(context) {
    if (!context) {
      return '0';
    }
    if (typeof context !== 'number') {
      return context;
    }
    return context.toCommas();
  });

  Handlebars.registerHelper('starray', function(context) {
    context = _.str.toSentence(context);
    context = context.replace(/\%26/g, '&');
    return context;
  });

  Handlebars.registerHelper('if_eq', function(context, options) {
    if (context === options.hash.compare) {
      return options.fn(this);
    }
    return options.inverse(this);
  });

  // Highcharts
  (function(H) {
    H.wrap(H.Legend.prototype, 'render', function (proceed) {
      var chart = this.chart;
      var h;

      proceed.call(this);

      if (this.options.adjustChartSize && this.options.verticalAlign === 'bottom') {
        h = this.legendHeight - 100;
        chart.chartHeight += h;
        chart.marginBottom += h;
        chart.container.style.height = chart.container.firstChild.style.height = chart.chartHeight + 'px';

        this.group.attr({
          translateY: this.group.attr('translateY') + h
        });
      }
    });
  } (Highcharts));

  // Initialize
  new SpinView();
  new IntroView();
  new TitleView();
  new FiltersView();
  new SummaryView();
  new BudgetsView();
  new ActionsView();
  new LimitationsView();

  new TimelineChartsView();
  new DonorsSnapshotView();
  new OrganizationsSnapshotView();
  new CountriesSnapshotView();
  new SectorsSnapshotView();

  new DonorsListView();
  new OrganizationsListView();
  new ProjectsListView();
  new CountriesListView();
  new SectorsListView();

  new FiltersFormView();

});
