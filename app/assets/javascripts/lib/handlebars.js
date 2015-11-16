define(['handlebarsLib'], function(Handlebars) {

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

  return Handlebars;

});
