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

var LIGHT_PAGES = ['/users/sign_in', '/users/sign_up', '/users/'];
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