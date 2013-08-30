$(function () {
  $("#week_menu a").each(function () {
    var query_string = window.location.search.substring(1);
    if (query_string != '' && $(this).attr('href') === "?" + query_string) {
      $(this).addClass("selected_link");
      return false;
    }
    else {
      $(this).addClass("selected_link");
      window.location.pathname == '/?week=' + $(this);
      return false;
    }
  });
});

$(function () {
  $(".hide_on_login").each(function () {
    if (window.location.pathname == '/users/sign_in' || window.location.pathname == '/users/sign_up') {
      $(this).hide();
    }
    else {
      $(this).show();
    }
  });
});