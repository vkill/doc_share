//= require jquery_uri/jquery.uri


// enbale per_page 
$(document).ready(function() {
  var uri = $.uri(window.location.href);

  $("a[data-per-page]").each(function(){
    var current_per_page = uri.at('query').per_page || $(this).data('default-per-page')

    if (current_per_page == $(this).html()) {
      $(this).attr('class', $(this).data('link-class'))
    }

    new_uri = uri.at({ query: { per_page: $(this).html() }});
    $(this).attr('href', new_uri)
  })
});
