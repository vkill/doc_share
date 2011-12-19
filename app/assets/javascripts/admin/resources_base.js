$(document).ready(function() {
  $("th a.sort_link").each(function(){
    $(this).twipsy({
      live: true,
      html: true,
      title: function(){
        return $("#popover-twipsy-sort-link").html()
      }
    })
  })
})
