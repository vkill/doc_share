$(document).ready(function() {
  $("a img.gravatar").each(function(){
    $(this).twipsy({
      live: true,
      html: true,
      placement: 'right',
      title: function(){
        return $("#popover-twipsy-change-gravatar").html()
      }
    })
  })
})