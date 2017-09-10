var LIGHT_PAGES = ['/users/sign_in', '/users/sign_up', '/users/', '/users/edit', '/users/password/new', '/users/password/edit'];
$(function () {
  $(".hide_on_login").each(function () {
    if ($.inArray(window.location.pathname, LIGHT_PAGES) != -1) {
      $(this).hide();
    }
    else {
      $(this).show();
    }
  });
});

$(document).ready(function () {
  if ($('#error_explanation').text().length > 0) {
    $('#errors').hide().delay(800).slideDown(800).delay(4000).slideUp(800);
  }
});

// RESET BET FUNCTION IF WE WANT IT - Need to add logic in bet submit to clear db values
//$(document).ready(function () {
//  $("#reset_bet").click(function () {
//    $(this).parent().parent().parent().parent().find('input').removeAttr('checked');
//    $(this).parent().parent().parent().parent().find('option').removeAttr('selected');
//  });
//});

$(document).ajaxComplete(function (event, request) {
//  $('#bets select').each(function() {
//    $(this).attr('savedValue', $(this).val());
//  });


  var msg;
  var alert_msg;
  if (request.getResponseHeader('X-Flash-Notice')) {
    msg = request.getResponseHeader('X-Flash-Notice');
  }
  else if (request.getResponseHeader('X-Flash-Error')) {
    alert_msg = request.getResponseHeader('X-Flash-Error');
  }

  if (msg && msg.length > 0) {
    $('#notice').html('<i class="fa fa-check-square-o notice_check" aria-hidden="true"></i>' + msg);
    $('#alert').html('');

    if ($('#notice').text().length > 0) {
      $('#notices').hide().delay(800).slideDown(800).delay(4000).slideUp(800);
      $('html, body').animate({ scrollTop: 0 }, 'slow');
    }
  }

  if (alert_msg && alert_msg.length > 0) {
    $('#alert').html('<i class="fa fa-exclamation-triangle notice_tri" aria-hidden="true"></i>' + alert_msg);
    $('#notice').html('');

    if ($('#alert').text().length > 0) {
      $('#notices').hide().delay(800).slideDown(800).delay(4000).slideUp(800);
      $('html, body').animate({ scrollTop: 0 }, 'slow');
    }
  }

//  if($('#bets input:first').attr('savedValue')!=undefined) {
//    // Have saved values, reset to last saved values
//    $('#bets input').each(function() {
//      $(this).val($(this).attr('savedValue'));
//    });
//  }
//  else {
//    // No saved values, reset form
//    $('#bets')[0].reset();
//  }


});

$(document).ready(function (event, request) {
  if ($('#notice').text().length > 0 || $('#alert').text().length > 0)  {
    $('#notices').hide().delay(800).slideDown(800).delay(4000).slideUp(800);
  }
  $('html, body').animate({ scrollTop: 0 }, 'slow');

  $('#edit_user').submit(function() {
    if($('#user_timezone').val() == '' || $('#user_timezone').val() == null) {
      alert( "Please select your local timezone!" );
      $('#user_timezone').focus() ;
      return false;
    }
  })
});




