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
  $("a[rel=twipsy]")
    .twipsy({
      live: true
    })
})
$(function () {
  $("a[rel=twipsy][data-disable-click]")
    .click(function(e) {
      e.preventDefault()
    })
})
$(function () {
  $("[data-twipsy]")
    .twipsy({
      live: true
    })
})
$(function () {
  $("[data-twipsy-title-div]").each(function(){
    $(this).twipsy({
      live: true,
      html: true,
      title: function(){
        return $(".popover#" + $(this).data("title-div")).html()
      }
    })
  })
})



// enable popover on a and data-popover
$(function () {
  $("a[rel=popover]")
    .popover({
      offset: 10,
      live: true
    })
})
$(function () {
  $("a[rel=popover][data-disable-click]")
    .click(function(e) {
      e.preventDefault()
    })
})
$(function () {
  $("[data-popover]")
    .popover({
      offset: 10,
      live: true
    })
})
$(function () {
  $("[data-popover-content-div]").each(function(){
    $(this).popover({
      offset: 10,
      live: true,
      html: true,
      content: function(){
        return $(".popover#" + $(this).data("content-div")).html()
      }
    })
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
      if (btn.attr('disabled') == 'disabled') {
        return false
      } else {
        btn.button('loading')
        requestId = Math.random() + Math.random() + Math.random()
        btn.attr("data-request-id", requestId)
        setTimeout("buttomRequestTimeout(" + requestId + ")", 8000)
      }
    })
  })
})

