// Swap menu active state for pjax requests
var navSelector = '.nav a';
$(navSelector).click(function() {
  $('.nav li.active').removeClass('active');
  $(this).parent('li').addClass('active');
})	

// Update menu clue counter for pjax links which cost clues
var clueLinkSelector = 'a[data-clue-cost]';
$(clueLinkSelector).live('click', function() {
  var counter = $('#clue-counter');
  var val = parseInt(counter.html().replace(/[^\d]/, ''));
  var newVal = (val - 1 !== 1) ? (val-1)+' clues' : '1 clue'
  counter.html(newVal);
})