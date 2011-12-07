$(document).ready(function() {
  $("[data-uploadify]").each(function(){
    var data = {}
    data[$("meta[name=csrf-param]").attr('content')] = encodeURIComponent($("meta[name=csrf-token]").attr('content'))
    data['_http_accept'] = 'application/javascript'
    data['_method'] = "put"
    data['utf8'] = "true"
    data[$(this).data("session-key")] = encodeURIComponent($(this).data("session-value"))

    $(this).uploadify({
      swf             : $(this).data("swf"),
      cancelImage     : $(this).data("cancelimage"),
      uploader        : $(this).data("uploader"),
      checkExisting   : $(this).data("checkexisting"),
      debug           : $(this).data("debug"),
      auto            : false,
      buttonText      : "选择文件",
      width           : 80,
      height          : 30,
      fileObjName     : $(this).data("fileobjname"),
      fileSizeLimit   : 2097152,
      queueSizeLimit  : 10485760,
      fileTypeDesc    : 'TXT Files',
      fileTypeExts    : '*.txt',
      method          : 'post',
      multi           : true,
      uploaderType    : 'flash',
      postData        : data,
      onComplete      : function(a, b, c, response){ eval(response) }
    });
  });

  $("[data-uploadify-start-upload]").click(function(){
    $("#" + $(this).data("association-uploader-id")).uploadifyUpload('*')
  })

  $("[data-uploadify-stop-upload]").click(function(){
    $("#" + $(this).data("association-uploader-id")).uploadifyStop('*')
  })
});

