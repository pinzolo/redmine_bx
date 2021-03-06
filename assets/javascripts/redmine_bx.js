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
  if ($("#form_database_id").val() !== "") {
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

if (typeof sizables !== "undefined" && typeof scalables !== "undefined") {
  var selected_data_type_id = $("#form_data_type_id").val();
  if (selected_data_type_id !== "") {
    $("#form_size").prop("disabled", !sizables[selected_data_type_id]);
    $("#form_scale").prop("disabled", !scalables[selected_data_type_id]);
  }
  $("#form_data_type_id").on("change", function() {
    $("#form_size").prop("disabled", !sizables[$(this).val()]);
    $("#form_scale").prop("disabled", !scalables[$(this).val()]);
  });
}

if ($(".bx-display-note").size() > 0) {
  $(".bx-display-note").on("click", function() {
    $("#bx_note_dialog").html($(this).next().html()).dialog({
      modal: true,
      buttons: {
        "OK": function() {
          $(this).dialog("close");
        }
      },
      height: "auto",
      width: "500px"
    });
  });
}

if ($("#form_reference_table_def_id").size() > 0) {
  $(".bx-table-columns-selection").each(function() {
    var p = $(this);
    var s = p.find("select");
    if (s.attr("id") === "bx_reference_column_candidates_" + $("#form_reference_table_def_id").val()) {
      p.show();
      s.prop("disabled", false);
    } else {
      p.hide();
      s.prop("disabled", true).val("");
    }
  });
  $("#form_reference_table_def_id").on("change", function() {
    $(".bx-table-columns-selection").hide().find("select").prop("disabled", true).val("");
    $("#bx_reference_column_candidates_" + $(this).val()).prop("disabled", false).parent().show();
  });
}
