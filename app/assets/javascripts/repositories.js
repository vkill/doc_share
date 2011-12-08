$(function() {
  $('#jquery_fileupload_repo').fileupload();
  $('#jquery_fileupload_repo').fileupload('option', {
    maxFileSize: 5000000,
    acceptFileTypes: /(\.|\/)(txt)$/i
  });
});

