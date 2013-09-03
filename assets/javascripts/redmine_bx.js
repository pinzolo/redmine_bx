if ($.jstree) {
  $(".bx-resources").each(function() {
    $(this).jstree({
      "plugins" : ["html_data", "cookies", "ui"]
    })
    .on("select_node.jstree", function(event, data) {
      window.location = data.selected.find("a").attr("href");
    });
  });
}

$("#form_leaf").on("click", function() {
  var checked = $(this).prop("checked");
  $(".bx-branch-value").each(function() {
    $(this).prop("disabled", !checked);
  });
});
