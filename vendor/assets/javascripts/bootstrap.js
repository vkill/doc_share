//= require bootstrap/bootstrap-modal
//= require bootstrap/bootstrap-alerts
//= require bootstrap/bootstrap-twipsy
//= require bootstrap/bootstrap-popover
//= require bootstrap/bootstrap-dropdown
//= require bootstrap/bootstrap-scrollspy
//= require bootstrap/bootstrap-tabs
//= require bootstrap/bootstrap-buttons

// enable twipsy
$(document).ready(function() {
  $("a[rel=twipsy]")
    .twipsy({
      live: true
    })
})
$(document).ready(function() {
  $("a[rel=twipsy][data-disable-click]")
    .click(function(e) {
      e.preventDefault()
    })
})
$(document).ready(function() {
  $("[data-twipsy]")
    .twipsy({
      live: true
    })
})
$(document).ready(function() {
  $("[data-twipsy-title-div]").each(function(){
    $(this).twipsy({
      live: true,
      html: true,
      title: function(){
        return $(".popover#" + $(this).data("twipsy-title-div")).html()
      }
    })
  })
})



// enable popover on a and data-popover
$(document).ready(function() {
  $("a[rel=popover]")
    .popover({
      offset: 10,
      live: true
    })
})
$(document).ready(function() {
  $("a[rel=popover][data-disable-click]")
    .click(function(e) {
      e.preventDefault()
    })
})
$(document).ready(function() {
  $("[data-popover]")
    .popover({
      offset: 10,
      live: true
    })
})
$(document).ready(function() {
  $("[data-popover-title-div]").each(function(){
    $(this).popover({
      offset: 10,
      live: true,
      html: true,
      title: function(){
        return $(".popover#" + $(this).data("popover-title-div")).html()
      }
    })
  })
})
$(document).ready(function() {
  $("[data-popover-content-div]").each(function(){
    $(this).popover({
      offset: 10,
      live: true,
      html: true,
      content: function(){
        return $(".popover#" + $(this).data("popover-content-div")).html()
      }
    })
  })
})
$(document).ready(function() {
  $("[data-popover-title-content-div]").each(function(){
    $(this).popover({
      offset: 10,
      live: true,
      html: true,
      title: function(){
        return $(".popover#" + $(this).data("title-div")).html()
      },
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
    $(this).click(function () {
      if ($(this).attr('disabled') == 'disabled') {
        return false
      } else {
        $(this).button('loading')
        requestId = Math.random() + Math.random() + Math.random() + Math.random()
        $(this).attr("data-request-id", requestId)
        setTimeout("buttomRequestTimeout(" + requestId + ")", 8000)
      }
    })
  })
})

