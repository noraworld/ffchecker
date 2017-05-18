$(function() {

  'use strict';

  $(document).on('click', '.follow', function() {
    var _this = $(this);
    var username = $(this).attr('name');
    $.ajax({
      type: 'POST',
      url: '/follow/' + username
    })
    .done(function(res) {
      _this.removeClass('follow');
      _this.addClass('unfollow');
      _this.attr({'value': 'フォロー解除'});
    })
    .fail(function(err) {
      alert('フォローに失敗しました。しばらく待ってからページをリロードしてもう一度お試しください。');
    });
  });

});
