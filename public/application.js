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
    $.ajax({
      type: 'POST',
      url: '/game/player_hit'
    }).done(function(msg) {
      $('#game').replaceWith(msg);
    });
    return false;
  });
});
