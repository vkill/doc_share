//= require bootstrap/bootstrap-modal
//= require bootstrap/bootstrap-alerts
//= require bootstrap/bootstrap-twipsy
//= require bootstrap/bootstrap-popover
//= require bootstrap/bootstrap-dropdown
//= require bootstrap/bootstrap-scrollspy
//= require bootstrap/bootstrap-tabs
//= require bootstrap/bootstrap-buttons

$(function () {
  $("a[rel=twipsy]").twipsy({
    live: true
  })
})


$(function() {
  var btn = $("[data-buttons]").click(function () {
    btn.button('loading')
    setTimeout(function () {
      if (btn.html() != btn.data("complete-text")) {
        btn.button('timeout')
        setTimeout(function (){ btn.button('reset') },3000);
      }
    }, 8000)
  })
})

