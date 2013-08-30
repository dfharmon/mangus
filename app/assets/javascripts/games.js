$(function() {
  $("#week_menu a").each(function() {
    var query_string = window.location.search.substring(1);
    if ($(this).attr('href')  ===  "?" + query_string) {
      $(this).addClass("selected_link");
    }
  });
});