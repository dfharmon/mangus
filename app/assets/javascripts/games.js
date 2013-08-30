$(function () {
  $("#week_menu a").each(function () {
    var query_string = window.location.search.substring(1);
    if (query_string == "") {
      $(this).addClass("selected_link");
      return false;
    }
    else if ($(this).attr('href') === "?" + query_string) {
      $(this).addClass("selected_link");
    }
  });
});

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
  //if ($('#error_explanation').text().length > 0) {
    $('#errors').hide().delay(800).slideDown(800).delay(4000).slideUp(800);
  //}
});


