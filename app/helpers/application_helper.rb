module ApplicationHelper
  def uploadify(type="repo_file")



    session_key_name = Rails.application.config.session_options[:key]
    %Q`

    <script type='text/javascript'>
      $(document).ready(function() {
        $("#repo_file_uploadify").uploadify({
          swf             : '#{ asset_path("uploadify.swf") }',
          uploader        : '#{ repository_path(@repository) }',
          checkExisting   : '',
          debug           : true,
          auto            : false,
          buttonText      : "select files",
          cancelImage     : '#{ asset_path("uploadify-cancel.png") }',
          fileObjName     : 'repo_file[repo_file]',
          fileSizeLimit   : #{2.megabytes},
          queueSizeLimit  : #{10.megabytes},
          fileTypeDesc    : 'TXT Files (*.txt)',
				  fileTypeExts    : '*.txt',
          method          : 'post',
				  multi           : true,
          uploaderType    : 'flash',
          width           : 120,
          height          : 30,
          postData      : {
            '_http_accept': 'application/javascript',
            '_method' : "put",
            'utf8' : "true",
            'authenticity_token'  : encodeURIComponent('#{u(form_authenticity_token)}'),
            '#{session_key_name}' : encodeURIComponent('#{u(cookies[session_key_name])}')
          },
          onComplete      : function(a, b, c, response){ eval(response) }
        });
      });
    </script>

    `.gsub(/[\n ]+/, ' ').strip.html_safe
  end

end

