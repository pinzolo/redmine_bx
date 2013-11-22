# coding: utf-8
module BxHelper
  def bx_tabs(tab = nil)
    content_tag(:div, :class => "tabs") do
      ul = content_tag(:ul) do
        if User.current.allowed_to?(:view_bx_resource_nodes, @project)
          link_opts = {}
          link_opts = link_opts.merge(:class => "selected") if tab.to_s == "bx_resources" || tab.nil?
          link = link_to(l("bx.menu.resources"), project_bx_resources_path(@project), link_opts)
          concat(content_tag(:li, link, :id => "tab-bx_resources"))
        end
        if User.current.allowed_to?(:view_bx_table_defs, @project)
          link_opts = {}
          link_opts = link_opts.merge(:class => "selected") if tab.to_s == "bx_table_defs"
          link = link_to(l("bx.menu.table_defs"), project_bx_table_defs_path(@project), link_opts)
          concat(content_tag(:li, link, :id => "tab-bx_table_defs"))
        end
      end
      concat(ul)
    end
  end

  def bx_title(*keys)
    title = l("bx.title.bx")
    if keys.present?
      keys.each do |key|
        title << " » "
        title << l("bx.title.#{key}")
      end
    end
    html_title(title)
    content_tag(:h2, title)
  end

  def bx_content_title(title_key)
    content_tag(:h3, l(title_key), :class => "bx-content-title")
  end

  def bx_form_label(form, attribute)
    l("activemodel.attributes.#{form.class.name.underscore}.#{attribute}")
  end

  def hbr(text)
    h(text).gsub(/\r\n/, "\n").gsub(/\n/, "<br />").html_safe
  end

  def bx_history_details_note(history, detail)
    operation_target = history.operation.gsub(/\A(create|update)_/, "")
    prop = l("bx.label.history_detail.properties.#{operation_target}.#{detail.property}")
    l("bx.text.history_detail_notes.#{history.operation_type}", :property => prop, :new_value => detail.new_value, :old_value => detail.old_value).html_safe
  end

  def bx_note(note)
    return "" if note.blank?

    div = content_tag(:div, :class => "bx-note-content") do
      concat(hbr(note))
    end
    link_to(l("bx.label.display_note"), "#", :class => "bx-display-note") + div
  end
end
