$(function() {

  'use strict';

  $(document).on('click', '.unfollow', function() {
    var _this = $(this);
    var username = $(this).attr('name');
    $.ajax({
      type: 'DELETE',
      url: '/unfollow/' + username
    })
    .done(function(res) {
      _this.removeClass('unfollow');
      _this.addClass('follow');
      _this.attr({'value': 'フォロー'});
    })
    .fail(function(err) {
      alert('フォロー解除に失敗しました。しばらく待ってからページをリロードしてもう一度お試しください。');
    });
  });

});
