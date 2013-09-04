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
    permission :bx_view_resources, :bx_resources => [:index, :show],
                                   :bx_resource_categories => [:show]
    permission :bx_manage_resources, :bx_resources => [:new, :edit, :create, :update, :destroy],
                                     :bx_resource_categories => [:new, :edit, :create, :update, :destroy],
                                     :bx_resource_branches => [:new, :edit, :create, :update, :destroy],
                                     :require => :member
    permission :view_bx_resource_nodes, :bx_resources => [:index, :show] # for search
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
      link_to(link_label, project_bx_resource_path(resource.project, resource))
    else
      ""
    end
  end
end

Redmine::Search.map do |search|
  search.register :bx_resource_nodes
end
