# coding: utf-8
module BxHelper
  def bx_tabs(name = "bx_resources", action = :bx_view_resources, partial = "index")
    puts "name: #{name}, action: #{action}, partial: #{partial}"
    tabs = [
      {:name => "bx_resources", :action => :bx_view_resources, :partial => "bx_resources/index", :label => "bx.menu.resources"}
      #,{:name => 'bx_table_defs', :action => :view_table_defs, :partial => 'bx_table_defs/index', :label => :label_bx_menu_table_defs}
    ]
    tabs.each do |tab|
      if tab[:name].to_s == name.to_s
        tab[:action] = action
        tab[:partial] = "#{name}/#{partial}"
      end
    end
    tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
  end

  def bx_title
    html_title(l("bx.label.bx"))
    content_tag(:h2, l("bx.label.bx"))
  end

  def bx_render_js(partial, options = {})
    %($("#tab-content-#{controller_name}").html("#{j(render(partial, options))}");).html_safe
  end

  def bx_form_label(form, attribute)
    l("activemodel.attributes.#{form.class.name.underscore}.#{attribute}")
  end
end
