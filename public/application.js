$(document).ready(function() {
  $('#game_menu').draggable({
    scroll: false,
    start: function(event, ui) {
      $(this).animate({
        padding: '+=25px'
      });
    },
    stop: function(event, ui) {
      $(this).animate({
        padding: '-=25px'
      }, 250);
    }
  });
  // $('#game_menu').mouseenter(function() {
  //   $(this).animate({
  //     height: '+=20px',
  //     width: '+=20px'
  //   });
  // });
  // $('#game_menu').mouseleave(function() {
  //   $(this).animate({
  //     height: '-=20px',
  //     width: '-=20px'
  //   });
  // });
});
