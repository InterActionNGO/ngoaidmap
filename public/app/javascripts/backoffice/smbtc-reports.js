'use strict';

(function() {

  function onDocumentReady() {
    $('.chzn-select').chosen();

    $('.select_date').find('select').chosen();
    alert($('form'));

    $('form').on('submit',function(e){
      e.preventDefault();
      alert("Hi");
      $.ajax({
          type     : "POST",
          cache    : false,
          url      : $(this).attr('action'),
          data     : $(this).serialize(),
          success  : function(data) {
              $("#results").empty().append(data);
          }
      });
    });
  }
})
