$(function() {

  'use strict';

  $(document).on('click', '.mute', function() {
    var _this = $(this);
    var username = $(this).attr('name');
    mute(_this, username);
  });

  $(document).on('click', '.unmute', function() {
    var _this = $(this);
    var username = $(this).attr('name');
    unmute(_this, username);
  });

  $(document).on('click', '#lump-mute', function() {
    var lump_elements = [];
    var lump_users = [];
    for (var i = 0; i < $('.lump').length; i++) {
      if ($('.lump').eq(i).prop('checked')) {
        lump_elements.push($('.lump').eq(i).next('.mute-button'));
        lump_users.push($('.lump').eq(i).attr('name'));
      }
    }
    for (var i = 0; i < lump_users.length; i++) {
      mute(lump_elements[i], lump_users[i]);
    }
  });

  function mute(_this, username) {
    $.ajax({
      type: 'POST',
      url: '/mute/' + username
    })
    .done(function(res) {
      _this.removeClass('mute');
      _this.addClass('unmute');
      _this.attr({'value': 'ミュート解除'});
    })
    .fail(function(err) {
      alert('ミュートに失敗しました。しばらく待ってからページをリロードしてもう一度お試しください。');
    });
  }

  function unmute(_this, username) {
    $.ajax({
      type: 'DELETE',
      url: '/unmute/' + username
    })
    .done(function(res) {
      _this.removeClass('unmute');
      _this.addClass('mute');
      _this.attr({'value': 'ミュート'});
    })
    .fail(function(err) {
      alert('ミュート解除に失敗しました。しばらく待ってからページをリロードしてもう一度お試しください。');
    });
  }

});
