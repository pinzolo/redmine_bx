if ($.jstree && $(".bx-resources").size() > 0) {
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

if ($("#form_database_id").size() > 0) {
  $(".bx-data-types").each(function() {
    $(this).removeClass("bx-data-types-selected");
    $(this).addClass("bx-data-types-unselected");
    $(this).find("input[type=checkbox]").prop("checked", false);
  });
  if ($("#form_database_id").val() != "") {
    $("#bx_data_types_" + $("#form_database_id").val())
      .removeClass("bx-data-types-unselected")
      .addClass("bx-data-types-selected")
      .find("input[data-default-checked=true]")
      .prop("checked", true);
  }
  $("#form_database_id").on("change", function() {
    $(".bx-data-types").each(function() {
      $(this).removeClass("bx-data-types-selected");
      $(this).addClass("bx-data-types-unselected");
      $(this).find("input[type=checkbox]").prop("checked", false);
    });
    $("#bx_data_types_" + $(this).val())
      .removeClass("bx-data-types-unselected")
      .addClass("bx-data-types-selected")
      .find("input[data-default-checked=true]")
      .prop("checked", true);
  });
}
