if ($.jstree) {
  $(".bx-resources").each(function() {
    $(this).jstree({
      "plugins" : ["html_data", "cookies", "themes"]
    });
  });
}

$("#form_leaf").on("click", function() {
  var checked = $(this).prop("checked");
  $(".bx-branch-value").each(function() {
    $(this).prop("disabled", !checked);
  });
});
