$(document).ready(function() {
  $("[data-twipst-change-gravatar]").each(function(){
    $(this).twipsy({
      live: true,
      html: true,
      placement: 'below',
      title: function(){
        return $("#popover-twipsy-change-gravatar").html()
      }
    })
  })
})