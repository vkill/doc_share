$(document).ready(function() {
  // Initialize the jQuery File Upload widget
  $('#jquery_fileupload_repo').fileupload({
  });

  // Set jQuery File Upload options
  $('#jquery_fileupload_repo').fileupload('option', {
    maxFileSize: 1000000000000,
    acceptFileTypes: /(\.|\/)(txt)$/i,
    sequentialUploads: true
  });

  // Load existing files:
  $.getJSON($('#jquery_fileupload_repo form').prop('action'), function (files) {
    var fu = $('#jquery_fileupload_repo').data('fileupload');
    fu._adjustMaxNumberOfFiles(-files.length);
    fu._renderDownload(files)
      .appendTo($('#jquery_fileupload_repo .files'))
      .fadeIn(function () {
        // Fix for IE7 and lower:
        $(this).show();
      });
  });

  $('#fileupload .files a:not([target^=_blank])').live('click', function (e) {
    e.preventDefault();
    $('<iframe style="display:none;"></iframe>')
    .prop('src', this.href)
    .appendTo('body');
  });

});

