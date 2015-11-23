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
    $.post('/game/player_hit').done(function(msg) {
      $('#game').replaceWith(msg);
      $.get('/game/game_menu_content').done(function(msg) {
        $('#game_menu_content').replaceWith(msg);
      });
    });
    return false;
  });
  $(document).on('click', '#double-btn', function() {
    $.post('/game/player_double').done(function(msg) {
      $('#game').replaceWith(msg);
      $.get('/game/game_menu_content').done(function(msg) {
        $('#game_menu_content').replaceWith(msg);
      });
    });
    return false;
  });
  $(document).on('click', '#dealer-btn', function() {
    $.post('/game/dealer_show').done(function(msg) {
      $('#game').replaceWith(msg);
      $.get('/game/game_menu_content').done(function(msg) {
        $('#game_menu_content').replaceWith(msg);
      });
    });
    return false;
  });
  $(document).on('click', '#stay-btn', function() {
    $.post('/game/player_stay').done(function(msg) {
      $('#game').replaceWith(msg);
      $.get('/game/game_menu_content').done(function(msg) {
        $('#game_menu_content').replaceWith(msg);
      });
    });
    return false;
  });
});
