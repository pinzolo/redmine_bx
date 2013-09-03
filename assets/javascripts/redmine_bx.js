if ($.jstree) {
  $(".bx-resources").each(function() {
    $(this).jstree({
      "plugins" : ["html_data", "cookies", "themes"],
      "themes" : { "icons" : false }
    }).jstree("hide_icons")
    .on("select_node.jstree", function(event, data) {
      window.location = data.selected.find("a").attr("href");
    });
  });
}
