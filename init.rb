# coding: utf-8
require "bx_hooks"

Redmine::Plugin.register :redmine_bx do
  name 'redmine_bx'
  author 'pinzolo'
  description 'redmine_bx is a plugin for Redmine. This will reduce excel files in your projects.'
  version '0.0.1'
  url 'https://github.com/pinzolo/redmine_bx'
  author_url 'https://github.com/pinzolo'

  project_module :bx do
    permission :view_bx_resource_nodes, :bx_resources => [:index, :show],
                                        :bx_resource_categories => [:show]
    permission :manage_bx_resource_nodes, :bx_resources => [:new, :edit, :create, :update, :destroy],
                                          :bx_resource_categories => [:new, :edit, :create, :update, :destroy],
                                          :bx_resource_branches => [:new, :edit, :create, :update, :destroy],
                                          :require => :member
    permission :view_bx_table_defs, :bx_table_defs => [:index, :show],
                                    :bx_table_groups => [:show]
    permission :manage_bx_table_defs, :bx_table_defs => [:new, :edit, :create, :update, :destroy],
                                      :bx_table_groups => [:new, :edit, :create, :update, :destroy],
                                      :bx_common_column_defs => [:new, :edit, :create, :update, :destroy, :up, :down],
                                      :bx_column_defs => [:new, :edit, :create, :update, :destroy, :up, :down],
                                      :require => :member
  end

  menu :project_menu, :bx, { :controller => :bx_resources, :action => :index }, :param => :project_id

  Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), "app", "{forms,services,validators}"))) do |dir|
    ActiveSupport::Dependencies.autoload_paths += [dir]
  end
end

Redmine::WikiFormatting::Macros.register do
  macro :bx_resource do |obj, args|
    resource_id = args.first
    resource = BxResourceNode.where(:id => resource_id).first
    if resource
      link_label = resource.code
      link_label << " : #{resource.summary}" if resource.summary.present?
      link_to(link_label, project_bx_resource_path(resource.project_id, resource))
    else
      ""
    end
  end
  macro :bx_table do |obj, args|
    table_id = args.first
    table_def = BxTableDef.where(:id => table_id).first
    if table_def
      link_label = table_def.physical_name
      link_label << " : #{table_def.logical_name}" if table_def.logical_name.present?
      link_to(link_label, project_bx_table_def_path(table_def.project_id, table_def))
    else
      ""
    end
  end
end

Redmine::Search.map do |search|
  search.register :bx_resource_nodes
end
