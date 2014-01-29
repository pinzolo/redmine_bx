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
                                      :bx_index_defs => [:new, :edit, :create, :update, :destroy],
                                      :require => :member
    permission :view_bx_templates, :bx_templates => [:index, :show]
    permission :manage_bx_templates, :bx_templates => [:new, :edit, :create, :update, :destroy],
                                     :require => :member
  end

  menu :admin_menu, :bx_databases, { :controller => :bx_databases, :action => :index}, :caption => :label_bx_database_plural
  menu :project_menu, :bx, { :controller => :bx_resources, :action => :index }, :param => :project_id

  Dir.glob(File.expand_path(File.join(File.dirname(__FILE__), "app", "{forms,services,validators}"))) do |dir|
    ActiveSupport::Dependencies.autoload_paths += [dir]
  end
end

require "bx_wiki_macros"
require "bx_search"

