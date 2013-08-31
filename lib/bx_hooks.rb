# coding: utf-8
class BxHooks < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context = {})
    return nil unless bx_rendering?(context[:controller])

    html = ""
    html << stylesheet_link_tag("redmine_bx", :plugin => "redmine_bx")
    html.html_safe
  end

  def view_layouts_base_body_bottom(context = {})
    return nil unless bx_rendering?(context[:controller])

    html = ""
    html << javascript_include_tag("jstree/jstree.min.js", :plugin => "redmine_bx") if Bx.rendering_tree
    html << "\n" + javascript_include_tag("redmine_bx", :plugin => "redmine_bx")
    html.html_safe
  end

  private
  def bx_rendering?(controller)
    controller.class.included_modules.include?(BxController)
  end
end
