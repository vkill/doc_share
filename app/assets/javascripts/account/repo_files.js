$(function() {
  var data = {}
  csrf_param = $("meta[name=csrf-param]").attr('content')
  csrf_token = $("meta[name=csrf-token]").attr('content')
  data[csrf_param] = csrf_token
  data['format'] = 'json'
  // Initialize the jQuery File Upload widget
  $('#jquery_fileupload_repo').fileupload({
    formData: data
  });

  // Set jQuery File Upload options
  $('#jquery_fileupload_repo').fileupload('option', {
    maxFileSize: 5000000,
    acceptFileTypes: /(\.|\/)(txt)$/i
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


});

