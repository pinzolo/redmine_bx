# coding: utf-8
module BxHelper
  def bx_tabs(tab = nil)
    content_tag(:div, :class => "tabs") do
      ul = content_tag(:ul) do
        if User.current.allowed_to?(:bx_view_resources, @project)
          link_opts = {}
          link_opts = link_opts.merge(:class => "selected") if tab.to_s == "bx_resources" || tab.nil?
          link = link_to(l("bx.menu.resources"), project_bx_resources_path(@project), link_opts)
          concat(content_tag(:li, link, :id => "tab-bx_resources"))
        end
      end
      concat(ul)
    end
  end

  def bx_title
    html_title(l("bx.label.bx"))
    content_tag(:h2, l("bx.label.bx"))
  end

  def bx_category_title(title_key)
    content_tag(:h3, l(title_key), :class => "bx_category_title")
  end

  def bx_form_label(form, attribute)
    l("activemodel.attributes.#{form.class.name.underscore}.#{attribute}")
  end

  def hbr(text)
    safe_text = h(text)
    text.gsub(/\r\n/, "\n").gsub(/\n/, "<br />").html_safe
  end
end