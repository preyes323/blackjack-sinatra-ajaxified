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
  $(document).on('click', '#hit-btn', function() {
    $('#player_well img:last-of-type').animate({
      marginLeft: '-=70px'
    });
    // , 400).promise().done( function() {
    //   alert('done');
    // });
    // return false;
  });
});
