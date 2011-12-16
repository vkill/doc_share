//= require jquery_ui_1.8.17/jquery.ui.core
//= require jquery_ui_1.8.17/jquery.ui.widget
//= require jquery_ui_1.8.17/jquery.ui.datepicker
//= require jquery_ui_1.8.17/i18n/jquery.ui.datepicker-zh-CN

$(document).ready(function() {
  $("input[data-date]").datepicker($.extend({}, $.datepicker.regional["zh-CN"], {}));
});