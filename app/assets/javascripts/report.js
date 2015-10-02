require([
  'underscore',
  '_string',
  'handlebars',
  'highcharts',

  'report/views/spin',
  'report/views/filters-form',
  'report/views/intro',
  'report/views/title',
  'report/views/filters',
  'report/views/summary',
  'report/views/budgets',
  'report/views/timeline-charts',
  'report/views/actions',
  'report/views/limitations',

  'report/views/donors-snapshot',
  'report/views/organizations-snapshot',
  'report/views/countries-snapshot',
  'report/views/sectors-snapshot',

  'report/views/donors-list',
  'report/views/organizations-list',
  'report/views/projects-list',
  'report/views/countries-list',
  'report/views/sectors-list'
], function(
  _, _string, Handlebars, Highcharts,
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
