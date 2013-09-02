var LIGHT_PAGES = ['/users/sign_in', '/users/sign_up', '/users/', '/users/edit'];
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
$(document).ready(function () {
  $("#reset_bet").click(function () {
    $(this).parent().parent().parent().parent().find('input').removeAttr('checked');
    $(this).parent().parent().parent().parent().find('option').removeAttr('selected');
  });
});

$(document).ajaxComplete(function (event, request) {
  var msg;
  if (request.getResponseHeader('X-Flash-Notice')) {
    msg = request.getResponseHeader('X-Flash-Notice');
  }
  else if (request.getResponseHeader('X-Flash-Alert')) {
    msg = request.getResponseHeader('X-Flash-Alert');
  }
  else if (request.getResponseHeader('X-Flash-Error')) {
    msg = request.getResponseHeader('X-Flash-Error');
  }

  if (msg) {
    $('#notice').html(msg);
  }
  if ($('#notice').text().length > 0) {
    $('#notices').hide().delay(800).slideDown(800).delay(4000).slideUp(800);
  }
  $('html, body').animate({ scrollTop: 0 }, 'slow');
});

$(document).ready(function (event, request) {
  if ($('#notice').text().length > 0) {
    $('#notices').hide().delay(800).slideDown(800).delay(4000).slideUp(800);
  }
  $('html, body').animate({ scrollTop: 0 }, 'slow');
});




