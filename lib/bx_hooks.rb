# coding: utf-8
class BxHooks < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context = {})
    if context[:controller].class.included_modules.include?(BxController)
      stylesheet_link_tag("redmine_bx", :plugin => "redmine_bx")
    end
  end

  def view_layouts_base_body_bottom(context = {})
    if context[:controller].class.included_modules.include?(BxController)
      javascript_include_tag("redmine_bx", :plugin => "redmine_bx")
    end
  end
end
