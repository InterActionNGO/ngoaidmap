// Original code from: http://ejohn.org/blog/jquery-livesearch/
// w/ slight modifications to allow full jquery expressions in the list

// USAGE:

// Add in the plugin with the following files:

//  <script type="text/javascript" src="jquery.liveupdate/quicksilver.js"></script>
//  <script type="text/javascript" src="jquery.liveupdate/jquery.liveupdate.js"></script>

// $('#your-input').liveUpdate('#list-id')
// If you have html or anchors in your list, remember it only strips out the innerHTML of each jquery elem
// $('#your-input').liveUpdate('ul#list-id a')
// You don't have to restrict this to just lists, you can also filter table rows and such
// $('#your-input').liveUpdate('#tbl tr td')

jQuery.fn.liveUpdate = function(list){
  list = jQuery(list);
  var cache;
  if ( list.length ) {
    cache = list.map(function(){
        return this.innerHTML.toLowerCase();
      });

    this
      .keyup(filter).keyup()
      .parents('form').submit(function(){
        return false;
      });
  }

  return this;

  function filter(){
    var term = jQuery.trim( jQuery(this).val().toLowerCase() ), scores = [];

    if ( !term ) {
      list.show();
    } else {
      list.hide();

      cache.each(function(i){
        var score = this.score(term);
        if (score > 0.9) { scores.push([score, i]); } // Change score
      });

      jQuery.each(scores.sort(function(a, b){return b[0] - a[0];}), function(){
        jQuery(list[ this[1] ]).show();
      });
    }
  }
};
