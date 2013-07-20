# coding: utf-8
module BxMenuHelper
  def bx_tabs
    tabs = [
      {:name => 'bx_resources', :action => :view_resources, :partial => 'bx_resources/index', :label => :label_bx_menu_resources}
      #,{:name => 'bx_table_defs', :action => :view_table_defs, :partial => 'bx_table_defs/index', :label => :label_bx_menu_table_defs}
    ]
    tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
  end
end
