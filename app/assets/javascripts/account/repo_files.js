$(document).ready(function() {
  // Initialize the jQuery File Upload widget:
  $('#jquery_fileupload_repo').fileupload(); 

  // Set jQuery File Upload options
  $('#jquery_fileupload_repo').fileupload('option', {
    maxFileSize: 1000000000000,
    acceptFileTypes: /(\.|\/)(txt)$/i,
    sequentialUploads: true
  });

  $('#jquery_fileupload_repo').each(function(){
    // Load existing files:
    $.getJSON($('#jquery_fileupload_repo form').prop('action'), function (files) {
      var fu = $('#jquery_fileupload_repo').data('fileupload'),
      template;
      fu._adjustMaxNumberOfFiles(-files.length);
      template = fu._renderDownload(files)
      .appendTo($('#jquery_fileupload_repo .files'));
      // Force reflow:
      fu._reflow = fu._transition && template.length &&
      template[0].offsetWidth;
      template.addClass('in'); 
    });
  })
  
  // Initialize the Bootstrap Image Gallery plugin:
  $('#jquery_fileupload_repo .files').imagegallery();

});

