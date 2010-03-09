// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// mostra um spinner automagicamente em qualquer chamada ajax
$(document).ready(function(){
  $(document).ajaxSend(function(event, request, settings){
    $('body > div.content').fadeTo('normal', 0.33);
    $('#loading').show();
  });
  $(document).ajaxComplete(function(event, request, settings){
    $('body > div.content').fadeTo('normal', 1);
    $('#loading').hide();
  });
});

function submit_bet(bet_form_id) {
  // TODO
}

