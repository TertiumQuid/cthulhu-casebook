//= require jquery
//= require jquery_ujs
//= require jquery.pjax
//= require facebook
//= require bootstrap-button
//= require bootstrap-tab
//= require bootstrap-dropdown
//= require header
//= require_self

var linkSelector = 'a:not([data-remote]):not([data-behavior]):not([data-skip-pjax]):not([data-method])';
$(linkSelector).pjax('[data-pjax-container]', {timeout: 2500});

$(document).on('pjax:success', function() {
});
$(document).on('pjax:start', function() {
});
$(document).on('pjax:error', function() {
});
$(document).on('pjax:end', function() {
});

$(document).on('ready', function() {
  $("[data-tabs='tabs'] li").first().tab();
  $("[data-tabs='tabs'] li").last().tab();
});