//= require bootstrap/bootstrap-modal
//= require bootstrap/bootstrap-alerts
//= require bootstrap/bootstrap-twipsy
//= require bootstrap/bootstrap-popover
//= require bootstrap/bootstrap-dropdown
//= require bootstrap/bootstrap-scrollspy
//= require bootstrap/bootstrap-tabs
//= require bootstrap/bootstrap-buttons

// enable twipsy
$(function () {
  $("a[rel=twipsy]").twipsy({
    live: true
  })
})


// enable buttons, timeout append error to alerts
function buttomRequestTimeout(requestId) {
  dom = $("[data-request-id='" + requestId + "']")
  if (dom.length != 0 ) {
    if (dom.attr('disabled') == 'disabled') {
      $("div#" + dom.data('alerts-containers-div')).append(
        "<div class='alert-message warning' data-alert=true><a class='close' href='#'>×</a><p>" + dom.data('timeout-text') + "</p></div>"
    )
      dom.button('reset')
    }
  }
}
$(function() {
  $("[data-buttons]").each(function(){
    btn = $(this).click(function () {
      if (btn.attr('disabled') == 'disabled') { return false }
      btn.button('loading')
      requestId = Math.random() + Math.random() + Math.random()
      btn.attr("data-request-id", requestId)
      setTimeout("buttomRequestTimeout(" + requestId + ")", 8000)
    })
  })
})

