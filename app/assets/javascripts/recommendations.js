
$(document).ready(function() {

  $('#new_comment #comment_content').focus(function(){
    $(this).css({height: '87px'});
    $('#new_comment .actions').removeClass('hidden');
    if ($(this).val().length <= 0) {
      $('#new_comment .actions .btn').addClass('disabled');
    }
  });

  $('#new_comment #comment_content').blur(function(){
    if ($(this).val().length <= 0) {
      $(this).css({height: '27px'});
      $('#new_comment .actions').addClass('hidden');
    }
  });

  $('#new_comment #comment_content').keyup(function(){
    if ($(this).val().length <= 0) {
      $('#new_comment .actions .btn').addClass('disabled');
    } else {
      $('#new_comment .actions .btn').removeClass('disabled');
    }
  });

});
