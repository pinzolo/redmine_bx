# coding: utf-8
class BxHooks < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context = {})
    if bx_rendering?(context[:controller])
      stylesheet_link_tag("redmine_bx", :plugin => "redmine_bx")
    end
  end

  def view_layouts_base_body_bottom(context = {})
    if bx_rendering?(context[:controller])
      html = javascript_include_tag("jstree/jstree.min.js", :plugin => "redmine_bx") + "\n"
      html << javascript_include_tag("redmine_bx", :plugin => "redmine_bx")
    end
  end

  private
  def bx_rendering?(controller)
    controller.class.included_modules.include?(BxController)
  end
end
